#############################################
################User Management##############
#############################################
resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = var.password_minimum_length
    require_lowercase = var.require_lowercase
    require_numbers   = var.require_numbers
    require_symbols   = var.require_symbols
    require_uppercase = var.require_uppercase
  }
  auto_verified_attributes = var.auto_verified_attributes
#  lambda_config {
#     post_confirmation = var.post_confirmation_arn
#   }
}

resource "aws_cognito_user_pool_client" "this" {
  name         = var.user_pool_client_name
  user_pool_id = aws_cognito_user_pool.this.id

  allowed_oauth_flows              = var.allowed_oauth_flows
  explicit_auth_flows              = var.explicit_auth_flows
  allowed_oauth_flows_user_pool_client = var.allowed_oauth_flows_user_pool_client
  allowed_oauth_scopes             = var.allowed_oauth_scopes
  callback_urls                    = var.callback_urls
  auth_session_validity           = 5

  depends_on = [
    aws_cognito_user_pool.this
  ]
}

resource "aws_cognito_user_group" "users_group" {
  user_pool_id = aws_cognito_user_pool.this.id
  name   = "Users"
  role_arn = var.user_role_arn
  description  = "Group for normal users"
}

resource "aws_cognito_user_group" "admins_group" {
  user_pool_id = aws_cognito_user_pool.this.id
  name   = "Admins"
  role_arn = var.admin_role_arn
  description  = "Group for admin users"
}


resource "aws_cognito_user_pool_domain" "main" {
  domain       = "equiluxenergy"
  user_pool_id = aws_cognito_user_pool.this.id
}