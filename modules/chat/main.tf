provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = var.repository_name
}

module "ecs" {
  source = "./modules/ecs"
  cluster_name  = var.cluster_name
  service_name  = var.service_name
  task_definition = module.ecr.task_definition
}

module "api_gateway" {
  source = "./modules/api_gateway"
  rest_api_name     = var.rest_api_name
  user_pool_id      = module.cognito.user_pool_id
  app_client_id     = module.cognito.app_client_id
  ecs_service_url   = module.ecs.service_url
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