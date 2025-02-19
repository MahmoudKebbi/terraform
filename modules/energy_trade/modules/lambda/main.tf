# User Trade Handler Lambda
resource "aws_lambda_function" "user_trade_handler" {
  function_name    = "user_trade_handler"
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  role             = var.aws_iam_role_lambda_user_role_arn
  filename         = var.user_trade_handler_filename
  source_code_hash = filebase64sha256("${var.user_trade_handler_filename}")

  environment {
    variables = {
      DYNAMODB_TABLE = var.aws_dynamodb_table_trades_name
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "user_trade_handler_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.user_trade_handler.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

# Admin Trade Handler Lambda
resource "aws_lambda_function" "admin_trade_handler" {
  function_name    = "admin_trade_handler"
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  role             = var.aws_iam_role_lambda_admin_role_arn
  filename         = var.admin_trade_handler_filename
  source_code_hash = filebase64sha256("${var.admin_trade_handler_filename}")

  environment {
    variables = {
      DYNAMODB_TABLE = var.aws_dynamodb_table_trades_name
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "admin_trade_handler_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.admin_trade_handler.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

# WebSocket Handler Lambda
resource "aws_lambda_function" "ws_handler" {
  function_name    = "ws_handler"
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  role             = var.aws_iam_role_lambda_ws_role_arn
  filename         = var.ws_handler_filename
  source_code_hash = filebase64sha256("${var.ws_handler_filename}")

  environment {
    variables = {
      WS_CONNECTIONS_TABLE = var.aws_dynamodb_table_ws_connections_name
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ws_handler_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.ws_handler.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

resource "aws_lambda_function" "ws_authorizer" {
  function_name    = "ws_authorizer"
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  role             = var.aws_iam_role_lambda_ws_role_arn
  filename         = var.ws_authorizer_filename
  source_code_hash = filebase64sha256("${var.ws_authorizer_filename}")

  environment {
    variables = {
      USER_POOL_ID = var.user_pool_id,
      REGION=var.region,
      USER_POOL_ID=var.user_pool_client_id
    }
  }
  tags = var.tags
}