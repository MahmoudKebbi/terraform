output "app_runner_task_role_arn" {
  description = "ARN of the App Runner task role"
  value       = aws_iam_role.app_runner_task_role.arn
}

output "app_runner_execution_role_arn" {
  description = "ARN of the App Runner execution role"
  value       = aws_iam_role.app_runner_execution_role.arn
}