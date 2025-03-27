output "table_name" {
  value = aws_dynamodb_table.equilux_chat.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.equilux_chat.arn
}