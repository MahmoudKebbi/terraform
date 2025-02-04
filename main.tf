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
region="eu-west-1"

}