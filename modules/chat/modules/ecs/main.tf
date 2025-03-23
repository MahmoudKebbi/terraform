resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = jsonencode([{
    name      = var.service_name
    image     = var.container_image
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_lb" "this" {
  name               = "${var.service_name}-lb"
  internal           = false
  load_balancer_type = "network"  # Changed from "application"
  subnets            = var.subnets
  # Remove security_groups - not needed for NLB
}

resource "aws_lb_target_group" "this" {
  name     = "${var.service_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

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
    container_port   = 80
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

