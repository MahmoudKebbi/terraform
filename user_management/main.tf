terraform {
  backend "s3" {
    bucket         = "my-terraform-state-equilux"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

module "cognito" {
  source = "./modules/cognito"

  user_pool_name                     = "user-management-pool"
  user_pool_client_name              = "user-management-client"
  password_minimum_length            = 8
  require_lowercase                  = true
  require_numbers                    = true
  require_symbols                    = true
  require_uppercase                  = true
  auto_verified_attributes           = ["email"]
  explicit_auth_flows                = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows                = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes               = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  callback_urls                      = ["https://example.com/callback"]
  post_confirmation_arn       = module.lambda.post_confirmation_arn
}

module "dynamodb" {
  source = "./modules/dynamodb"

  users_table_name       = "users"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "user_id"
  hash_key_type    = "S"
  additional_attributes = [
    {
      name = "email"
      type = "S"
    },
    {
      name = "username"
      type = "S"
    }
  ]
  server_side_encryption_enabled = true
  tags = {
    Environment = "dev"
    Project     = "user-management"
  }
}

module "iam" {
  source = "./modules/iam"

  region             = "eu-west-1"
  user_dynamodb_table_name = module.dynamodb.user_table_name
  user_pool_arn      = module.cognito.user_pool_arn
  post_confirmation_arn = module.lambda.post_confirmation_arn
}

module "lambda" {
  source = "./modules/lambda"

  function_prefix         = "user-management"
  handler                 = "index.handler"
  runtime                 = "nodejs18.x"
  user_management_role_arn                = module.iam.lambda_execution_role_arn
  create_user_filename    = "${path.module}/lambda_functions/create_user.zip"
  get_user_filename       = "${path.module}/lambda_functions/get_user.zip"
  update_user_filename    = "${path.module}/lambda_functions/update_user.zip"
  delete_user_filename    = "${path.module}/lambda_functions/delete_user.zip"
  post_confirmation_filename    = "${path.module}/lambda_functions/post_confirmation.zip"
  environment_variables   = {
    TABLE_NAME = module.dynamodb.user_table_name
  }
}

module "apigateway" {
  source = "./modules/apigateway"

  user_management_lambda_functions = {
    create_user = module.lambda.create_user_arn
    get_user    = module.lambda.get_user_arn
    update_user = module.lambda.update_user_arn
    delete_user = module.lambda.delete_user_arn
  }
  region = "eu-west-1"
  cognito_user_pool_arn = module.cognito.user_pool_arn
}