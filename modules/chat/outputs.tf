output "app_runner_service_url" {
  description = "The URL of the App Runner service"
  value       = module.app_runner.service_url
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}