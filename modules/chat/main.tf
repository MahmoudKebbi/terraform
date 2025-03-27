provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  name_prefix = local.name_prefix
  tags       = local.tags
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
  partition_key = var.dynamodb_partition_key
  sort_key = var.dynamodb_sort_key
  gsi1_partition_key = var.dynamodb_gsi1_partition_key
  gsi1_sort_key = var.dynamodb_gsi1_sort_key
  gsi2_partition_key = var.dynamodb_gsi2_partition_key
  gsi2_sort_key = var.dynamodb_gsi2_sort_key
}

module "iam" {
  source             = "./modules/iam"
  name_prefix        = local.name_prefix
  dynamodb_table_arn = module.dynamodb.table_arn
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = var.repository_name
}



module "app_runner" {
  source            = "./modules/app_runner"
  name_prefix       = local.name_prefix
  docker_image      = "${module.ecr.repository_url}:latest"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.vpc.app_runner_security_group_id
  task_role_arn     = module.iam.app_runner_task_role_arn
  execution_role_arn = module.iam.app_runner_execution_role_arn
  cpu               = "256"
  memory            = "512"
  tags              = local.tags
  user_pool_id      = var.user_pool_id
}