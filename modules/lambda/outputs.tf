output "user_functions" {
  description = "Map of User Lambda functions"
  value       = {for key, func in aws_lambda_function.user_functions : key => func}
}

output "transaction_functions" {
  description = "Map of Transaction Lambda functions"
  value       = {for key, func in aws_lambda_function.transaction_functions : key => func}
}

output "user_function_arns" {
  description = "ARNs of User Lambda functions"
  value       = {for key, func in aws_lambda_function.user_functions : key => func.arn}
}

output "transaction_function_arns" {
  description = "ARNs of Transaction Lambda functions"
  value       = {for key, func in aws_lambda_function.transaction_functions : key => func.arn}
}