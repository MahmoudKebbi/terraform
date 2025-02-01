#############################################
################User Management##############
#############################################
resource "aws_lambda_function" "create_user" {
  function_name = "${var.function_prefix}-create"
  handler       = var.handler
  runtime       = "nodejs18.x"  # Updated runtime
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "get_user" {
  function_name = "${var.function_prefix}-get"
  handler       = var.handler
  runtime       = "nodejs18.x"  # Updated runtime
  role          = var.user_management_role_arn
  filename      = var.get_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "update_user" {
  function_name = "${var.function_prefix}-update"
  handler       = var.handler
  runtime       = "nodejs18.x"  # Updated runtime
  role          = var.user_management_role_arn
  filename      = var.update_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "delete_user" {
  function_name = "${var.function_prefix}-delete"
  handler       = var.handler
  runtime       = "nodejs18.x"  # Updated runtime
  role          = var.user_management_role_arn
  filename      = var.delete_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "post_confirmation" {
  function_name = "${var.function_prefix}-post-confirmation"  # Ensure unique function name
  handler       = "post_confirmation.handler"
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.post_confirmation_filename

  environment {
    variables = var.environment_variables
  }
}