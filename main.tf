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