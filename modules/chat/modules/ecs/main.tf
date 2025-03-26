# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}

resource "aws_iam_role" "execution_role" {
  name = "${var.service_name}-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create a task role for the ECS task to access DynamoDB
resource "aws_iam_role" "task_role" {
  name = "${var.service_name}-task-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Attach DynamoDB access policy to the task role
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "dynamodb-access"
  role = aws_iam_role.task_role.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*"
        ]
      }
    ]
  })
}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  
  container_definitions    = jsonencode([{
    name      = var.service_name
    image     = var.container_image
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    environment = [
      {
        name = "PORT",
        value = "8080"
      },
      {
        name = "AWS_REGION",
        value = data.aws_region.current.name
      },
      {
        name = "NODE_ENV",
        value = "production"  # Change from localdev to production for ECS deployment
      },
      {
        name = "USE_VPC_ENDPOINT",
        value = "true"
      },
      {
        name = "USERS_TABLE",
        value = "Equilux_Users_Prosumers"
      },
      {
        name = "MESSAGES_TABLE",
        value = "Equilux_Messages"
      }
    ]
  }])
}

resource "aws_lb" "this" {
  name               = "${var.service_name}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
}

resource "aws_lb_target_group" "this" {
  name        = "${var.service_name}-tg"
  port        = 8080  # Change from 80 to 8080
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    protocol            = "TCP"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "8080"  # Change from 80 to 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }
  
  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.service_name
    container_port   = 8080  # Change from 80 to 8080
  }
  
  depends_on = [aws_lb_listener.this]
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 0
  max_capacity       = 1
}

# Scale up at 16:00 Beirut time (13:00-14:00 UTC depending on DST)
resource "aws_appautoscaling_scheduled_action" "scale_up" {
  name               = "scale-up"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  schedule           = "cron(0 13 * * ? *)"  # 13:00 UTC (covers both summer/winter)
  
  scalable_target_action {
    min_capacity = 1
    max_capacity = 1
  }
}

# Scale down at 2:00 Beirut time (00:00 UTC during winter)
resource "aws_appautoscaling_scheduled_action" "scale_down" {
  name               = "scale-down"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  schedule           = "cron(0 0 * * ? *)"  # 00:00 UTC
  
  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}

output "nlb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

