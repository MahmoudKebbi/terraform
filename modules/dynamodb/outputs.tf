output "users_table_name" {
  description = "Name of the Users DynamoDB table"
  value       = aws_dynamodb_table.users_table.name
}

output "users_table_arn" {
  description = "ARN of the Users DynamoDB table"
  value       = aws_dynamodb_table.users_table.arn
}

output "transactions_table_name" {
  description = "Name of the Transactions DynamoDB table"
  value       = aws_dynamodb_table.transactions_table.name
}

output "transactions_table_arn" {
  description = "ARN of the Transactions DynamoDB table"
  value       = aws_dynamodb_table.transactions_table.arn
}