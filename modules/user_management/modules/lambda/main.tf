#############################################
################User Management##############
#############################################

# User functions
resource "aws_lambda_function" "create_user" {
  function_name = "${var.function_prefix}-create"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "create_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.create_user.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "get_user" {
  function_name = "${var.function_prefix}-get"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.get_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "get_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.get_user.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "update_user" {
  function_name = "${var.function_prefix}-update"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.update_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "update_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.update_user.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "delete_user" {
  function_name = "${var.function_prefix}-delete"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.delete_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "delete_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.delete_user.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "post_confirmation" {
  function_name = "${var.function_prefix}-post-confirmation"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.post_confirmation_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "post_confirmation_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.post_confirmation.function_name}"
  retention_in_days = 14
}

# Admin functions
resource "aws_lambda_function" "list_all_users" {
  function_name = "${var.function_prefix}-list-all-users"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.list_all_users_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "list_all_users_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.list_all_users.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "assign_admin_role" {
  function_name = "${var.function_prefix}-assign-admin-role"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.assign_admin_role_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "assign_admin_role_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.assign_admin_role.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "revoke_admin_role" {
  function_name = "${var.function_prefix}-revoke-admin-role"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.revoke_admin_role_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "revoke_admin_role_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.revoke_admin_role.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "admin_get_user" {
  function_name = "${var.function_prefix}-admin-get"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.admin_get_user_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "admin_get_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.admin_get_user.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "admin_update_user" {
  function_name = "${var.function_prefix}-admin-update"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.admin_update_user_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "admin_update_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.admin_update_user.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "admin_delete_user" {
  function_name = "${var.function_prefix}-admin-delete"
  handler       = var.handler
  runtime       = "nodejs16.x"
  role          = var.user_management_role_arn
  filename      = var.admin_delete_user_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_cloudwatch_log_group" "admin_delete_user_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.admin_delete_user.function_name}"
  retention_in_days = 14
}