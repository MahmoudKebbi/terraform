#############################################
################User Management##############
#############################################
output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution_role.arn
}

output "admin_role_arn" {
  description = "The ARN of the admin policy"
  value       = aws_iam_role.admins_group_role.arn
}

output "user_role_arn" {
  description = "The ARN of the user policy"
  value       = aws_iam_role.users_group_role.arn
}

output "api_gateway_admin_role_arn"{
  description = "The ARN of the admin role"
  value       = aws_iam_role.api_gateway_admin_role.arn
}

output "api_gateway_user_role_arn"{
  description = "The ARN of the user role"
  value       = aws_iam_role.api_gateway_user_role.arn
}
