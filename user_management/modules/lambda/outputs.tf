#############################################
################User Management##############
#############################################
output "create_user_arn" {
  value = aws_lambda_function.create_user.arn
}

output "get_user_arn" {
  value = aws_lambda_function.get_user.arn
}

output "update_user_arn" {
  value = aws_lambda_function.update_user.arn
}

output "delete_user_arn" {
  value = aws_lambda_function.delete_user.arn
}

output "post_confirmation_arn" {
  value = aws_lambda_function.post_confirmation.arn
}