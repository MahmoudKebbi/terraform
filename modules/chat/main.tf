provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  aws_region = var.region
  vpc_cidr = var.vpc_cidr
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = var.repository_name
}


module "ecs" {
  source = "./modules/ecs"
  cluster_name      = var.cluster_name
  service_name      = var.service_name
  container_image   = "${module.ecr.repository_url}:latest"
  subnets           = module.vpc.private_subnets
  security_groups   = [module.vpc.ecs_security_group_id]
  vpc_id            = module.vpc.vpc_id
}

module "api_gateway" {
  source = "./modules/api_gateway"
  rest_api_name     = var.rest_api_name
  user_pool_arn      = var.user_pool_arn
  ecs_service_url   = module.ecs.service_url
  vpc_endpoint_id   = module.vpc.vpc_endpoint_id
  execute_role_arn  = module.iam.api_gateway_execute_role_arn
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


