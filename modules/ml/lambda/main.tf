resource "aws_lambda_function" "refit_all" {
  function_name = "${var.function_prefix}-refit-all"
  handler       = var.handler
  runtime       = "python.x"
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
  tags = var.tags
}

resource "aws_lambda_function" "predict_consumption_hourly" {
  function_name = "${var.function_prefix}-predict-consumption-hourly"
  handler       = var.handler
  runtime       = "python.x"
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
  tags = var.tags
}

resource "aws_lambda_function" "predict_consumption_daily" {
  function_name = "${var.function_prefix}-predict-consumption-daily"
  handler       = var.handler
  runtime       = "python.x"
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
  tags = var.tags
}

resource "aws_lambda_function" "predict_production_hourly" {
  function_name = "${var.function_prefix}-predict-production-hourly"
  handler       = var.handler
  runtime       = "python.x"
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
  tags = var.tags
}