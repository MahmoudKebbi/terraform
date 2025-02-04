#############################################
################User Management##############
#############################################
output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution_role.arn
}

output "admin_role_arn" {
  description = "The ARN of the admin policy"
  value       = aws_iam_policy.admin_policy.arn
}

output "user_role_arn" {
  description = "The ARN of the user policy"
  value       = aws_iam_policy.user_policy.arn
}
