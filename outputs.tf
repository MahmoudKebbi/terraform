# DynamoDB Outputs
output "users_table_name" {
  description = "Name of the Users DynamoDB table"
  value       = module.dynamodb.users_table_name
}

output "users_table_arn" {
  description = "ARN of the Users DynamoDB table"
  value       = module.dynamodb.users_table_arn
}

output "transactions_table_name" {
  description = "Name of the Transactions DynamoDB table"
  value       = module.dynamodb.transactions_table_name
}

output "transactions_table_arn" {
  description = "ARN of the Transactions DynamoDB table"
  value       = module.dynamodb.transactions_table_arn
}

# Lambda Outputs
output "user_function_arns" {
  description = "ARNs of User Lambda functions"
  value       = module.lambda.user_function_arns
}

output "transaction_function_arns" {
  description = "ARNs of Transaction Lambda functions"
  value       = module.lambda.transaction_function_arns
}

# API Gateway Outputs
output "api_id" {
  description = "ID of the API Gateway"
  value       = module.api_gateway.api_id
}

output "api_name" {
  description = "Name of the API Gateway"
  value       = module.api_gateway.api_name
}

# CloudWatch Outputs
output "lambda_log_group_names" {
  description = "Names of Lambda function log groups"
  value       = module.cloudwatch.lambda_log_group_names
}

output "cloudwatch_alarm_names" {
  description = "Names of CloudWatch alarms"
  value       = module.cloudwatch.alarm_names
}

# Security Outputs
output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.security.waf_web_acl_arn
}