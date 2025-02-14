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
  tags = var.tags  
  auto_verified_attributes = var.auto_verified_attributes
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

  supported_identity_providers = ["COGNITO", "Google"]

  depends_on = [
    aws_cognito_user_pool.this,
    aws_cognito_identity_provider.google
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

resource "aws_cognito_identity_provider" "google" {
  user_pool_id = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret
    authorize_scopes = "openid email profile"
  }

  attribute_mapping = {
    email = "email"
  }
}

resource "null_resource" "update_user_pool" {

  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp update-user-pool --user-pool-id ${aws_cognito_user_pool.this.id} --lambda-config PostConfirmation=${var.post_confirmation_arn} --auto-verified-attributes email
    EOT
  }
}