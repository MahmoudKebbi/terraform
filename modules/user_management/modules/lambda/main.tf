#############################################
################User Management##############
#############################################

# User functions
resource "aws_lambda_function" "create_user" {
  function_name = "${var.function_prefix}-create"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.create_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "get_user" {
  function_name = "${var.function_prefix}-get"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.get_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "update_user" {
  function_name = "${var.function_prefix}-update"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.update_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "delete_user" {
  function_name = "${var.function_prefix}-delete"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.delete_user_filename

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function" "post_confirmation" {
  function_name = "${var.function_prefix}-post-confirmation"
  handler       = "post_confirmation.handler"
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.post_confirmation_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

# Admin functions
resource "aws_lambda_function" "list_all_users" {
  function_name = "${var.function_prefix}-list-all-users"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.list_all_users_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_lambda_function" "assign_admin_role" {
  function_name = "${var.function_prefix}-assign-admin-role"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.assign_admin_role_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_lambda_function" "revoke_admin_role" {
  function_name = "${var.function_prefix}-revoke-admin-role"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.revoke_admin_role_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_lambda_function" "admin_get_user" {
  function_name = "${var.function_prefix}-admin-get"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.admin_get_user_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_lambda_function" "admin_update_user" {
  function_name = "${var.function_prefix}-admin-update"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.admin_update_user_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "aws_lambda_function" "admin_delete_user" {
  function_name = "${var.function_prefix}-admin-delete"
  handler       = var.handler
  runtime       = "nodejs18.x"
  role          = var.user_management_role_arn
  filename      = var.admin_delete_user_filename

  environment {
    variables = merge(var.environment_variables, {
      USER_POOL_ID = var.user_pool_id
    })
  }
}

resource "null_resource" "update_user_pool" {
  depends_on = [aws_lambda_function.post_confirmation]

  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp update-user-pool --user-pool-id ${var.user_pool_id} --lambda-config PostConfirmation=${aws_lambda_function.post_confirmation.arn}
    EOT
  }
}