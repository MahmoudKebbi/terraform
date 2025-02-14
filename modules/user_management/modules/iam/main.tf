#############################################
################User Management##############
#############################################
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda-policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable",
          "dynamodb:UpdateTable"
        ],
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.user_dynamodb_table_name}"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:AdminAddUserToGroup",
          "cognito-idp:AdminRemoveUserFromGroup",
          "cognito-idp:ListGroups",
          "cognito-idp:ListUsersInGroup",
          "cognito-idp:AdminUpdateUserAttributes",
          "cognito-idp:AdminDeleteUser",
          "cognito-idp:AdminGetUser"
        ],
        Resource = [
          "arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${var.user_pool_id}"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_cognito_policy" {
  name        = "lambda-cognito-policy"
  description = "Policy for Lambda functions to manage Cognito user groups"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:AdminAddUserToGroup",
          "cognito-idp:AdminRemoveUserFromGroup",
          "cognito-idp:ListGroups",
          "cognito-idp:ListUsersInGroup"
        ],
        Resource = [
          "arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${var.user_pool_id}"
        ]
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_cognito_policy.arn
}

resource "aws_lambda_permission" "allow_cognito" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = var.post_confirmation_arn
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.user_pool_arn
}


resource "aws_iam_role" "users_group_role" {
  name = "users-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role" "admins_group_role" {
  name = "admins-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_policy" "user_policy" {
  name        = "user-policy"
  description = "Policy for normal users to access specific endpoints"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          var.create_user_arn,
          var.get_user_arn,
          var.update_user_arn,
          var.delete_user_arn
        ]
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_policy" "admin_policy" {
  name        = "admin-policy"
  description = "Policy for admins to access all endpoints"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "users_policy_attachment" {
  role       = aws_iam_role.users_group_role.name
  policy_arn = aws_iam_policy.user_policy.arn
}

resource "aws_iam_role_policy_attachment" "admins_policy_attachment" {
  role       = aws_iam_role.admins_group_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_role" "user_profile_management_role" {
  name = "user-profile-management-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role" "api_gateway_user_role" {
  name = "api-gateway-user-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}
resource "aws_iam_role_policy" "api_gateway_user_policy" {
  name   = "api-gateway-user-policy"
  role   = aws_iam_role.api_gateway_user_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "lambda:InvokeFunction",
        Resource = [
          var.create_user_arn,
          var.get_user_arn,
          var.update_user_arn,
          var.delete_user_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "api_gateway_admin_role" {
  name = "api-gateway-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "api_gateway_admin_policy" {
  name   = "api-gateway-admin-policy"
  role   = aws_iam_role.api_gateway_admin_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "lambda:InvokeFunction",
        Resource = [
          var.list_all_users_arn,
          var.assign_admin_role_arn,
          var.revoke_admin_role_arn,
          var.admin_get_user_arn,
          var.admin_update_user_arn,
          var.admin_delete_user_arn
        ]
      }
    ]
  })
}

