output "repository_url" {
  value = module.ecr.repository_url
}

output "ecs_service_url" {
  value = module.ecs.service_url
}


output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}