terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "apigateway"{
    source = "./modules/apigateway"
    region=var.region
    user_pool_arn=var.user_pool_arn
    aws_iam_role_lambda_user_role_arn=module.iam.aws_iam_role_lambda_user_role_arn
    aws_iam_role_lambda_admin_role_arn=module.iam.aws_iam_role_lambda_admin_role_arn
    aws_lambda_function_trade_invoke_arn=module.lambda.aws_lambda_function_trade_invoke_arn
    aws_lambda_function_trade_admin_invoke_arn=module.lambda.aws_lambda_function_trade_admin_invoke_arn
    aws_lambda_function_ws_handler_invoke_arn=module.lambda.aws_lambda_function_ws_handler_invoke_arn
    aws_lambda_function_ws_handler_function_name=module.lambda.aws_lambda_function_ws_handler_function_name
    cognito_user_pool_client_id=var.user_pool_client_id
    apigateway_admin_role_arn=module.iam.apigateway_admin_role_arn
    apigateway_user_role_arn=module.iam.apigateway_user_role_arn
    ws_authorizer_lambda_arn=module.lambda.ws_authorizer_lambda_arn
}

module "lambda"{
    source = "./modules/lambda"
    region=var.region
    aws_iam_role_lambda_user_role_arn=module.iam.aws_iam_role_lambda_user_role_arn
    aws_iam_role_lambda_admin_role_arn=module.iam.aws_iam_role_lambda_admin_role_arn
    aws_iam_role_lambda_ws_role_arn=module.iam.aws_iam_role_lambda_ws_role_arn
    aws_dynamodb_table_trades_name=module.dynamodb.aws_dynamodb_table_trades_name
    aws_dynamodb_table_ws_connections_name=module.dynamodb.aws_dynamodb_table_ws_connections_name
    user_trade_handler_filename="${path.module}/lambda_functions/user/user_trade_handler.zip"
    admin_trade_handler_filename="${path.module}/lambda_functions/admin/admin_trade_handler.zip"
    ws_handler_filename="${path.module}/lambda_functions/ws/ws_handler.zip"
    ws_authorizer_filename="${path.module}/lambda_functions/ws/ws_authorizer.zip"
    tags=var.tags
    user_pool_client_id=var.user_pool_client_id
    user_pool_id=var.user_pool_id
}

module "dynamodb"{
    source = "./modules/dynamodb"
    server_side_encryption_enabled=true
}

module "iam"{
    source = "./modules/iam"
    aws_dynamodb_table_ws_connections_arn=module.dynamodb.aws_dynamodb_table_ws_connections_arn
    aws_dynamodb_table_trades_arn=module.dynamodb.aws_dynamodb_table_trades_arn
    aws_lambda_function_trade_invoke_arn=module.lambda.aws_lambda_function_trade_invoke_arn
    aws_lambda_function_trade_admin_invoke_arn=module.lambda.aws_lambda_function_trade_admin_invoke_arn
    aws_lambda_function_ws_handler_invoke_arn=module.lambda.aws_lambda_function_ws_handler_invoke_arn
}



