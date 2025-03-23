terraform {
  backend "s3" {
    bucket         = "my-terraform-state-equilux"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}


module "user_managment"{
source="./modules/user_management"
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
  callback_urls        = var.callback_urls
  tags = var.user_management_tags
}

module "energy_trade"{
  source="./modules/energy_trade"
  region=var.region
  user_pool_arn=module.user_managment.user_pool_arn
  user_pool_client_id=module.user_managment.user_pool_client_id
  tags = var.energy_trade_tags
  user_pool_id=module.user_managment.user_pool_id
}

module "chat" {
  source = "./modules/chat"
  region = var.region
  
  vpc_cidr                = "10.0.0.0/16"
  repository_name         = "equilux-chat-repo"
  cluster_name            = "equilux-chat-cluster"
  service_name            = "equilux-chat-service"
  user_pool_arn           = module.user_managment.user_pool_arn
  rest_api_name           = "equilux-chat-api"
  dynamodb_table_name     = "Equilux_Messages"
  dynamodb_partition_key  = "conversationId"
  dynamodb_sort_key       = "timestamp"
  dynamodb_gsi1_partition_key = "senderId"
  dynamodb_gsi1_sort_key  = "timestamp"
  dynamodb_gsi2_partition_key = "receiverId"
  dynamodb_gsi2_sort_key  = "timestamp"
  
}