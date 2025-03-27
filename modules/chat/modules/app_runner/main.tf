resource "aws_apprunner_service" "service" {
  service_name = var.name_prefix

  source_configuration {
    image_repository {
      image_configuration {
        port = "8080"  # Changed to match your PORT environment variable
        runtime_environment_variables = {
          NODE_ENV = "production"
          PORT = "8080"
          AWS_REGION = "eu-west-1"
          USE_VPC_ENDPOINT = "true"
          USERS_TABLE = "Equilux_Users_Prosumers"
          MESSAGES_TABLE = "Equilux_Messages"
          COGNITO_USER_POOL_ID = var.user_pool_id
          }
      }
      image_identifier      = var.docker_image
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = var.execution_role_arn
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }

  instance_configuration {
    cpu               = var.cpu
    memory            = var.memory
    instance_role_arn = var.task_role_arn
  }

  tags = var.tags

  depends_on = [
    aws_apprunner_vpc_connector.connector
  ]
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.name_prefix}-connector"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]
  
  tags = var.tags
}