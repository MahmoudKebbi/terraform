provider "aws" {
  region = var.aws_region

  default_tags {
    Key = "Project"
    Value = "Energy Platform"
    Propagate_at_launch = true
  }

  assume_role {
    role_arn = var.assume_role_arn
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  users_table_name         = var.users_table_name
  transactions_table_name  = var.transactions_table_name
  tags                     = var.tags
}

module "iam" {
  source = "./modules/iam"

  users_table_arn         = module.dynamodb.users_table_arn
  transactions_table_arn  = module.dynamodb.transactions_table_arn
}

module "lambda" {
  source = "./modules/lambda"

  lambda_execution_role_arn = module.iam.lambda_execution_role_arn
  users_table_name          = var.users_table_name
  transactions_table_name   = var.transactions_table_name
  tags                      = var.tags
}

module "api_gateway" {
  source = "./modules/api_gateway"

  lambda_user_functions         = module.lambda.user_functions
  lambda_transaction_functions  = module.lambda.transaction_functions
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  api_name               = module.api_gateway.api_name
  alarm_notification_arns = var.alarm_notification_arns
}

module "security" {
  source = "./modules/security"

  api_gateway_arn = module.api_gateway.api_gateway_arn
  blocked_ip_list = var.blocked_ip_list
  rate_limit      = var.rate_limit
}