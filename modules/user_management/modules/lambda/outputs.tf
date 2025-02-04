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

output "list_all_users_arn"{ 
  value = aws_lambda_function.list_all_users.arn
}

output "assign_admin_role_arn" {
  value = aws_lambda_function.assign_admin_role.arn
}

output "revoke_admin_role_arn" {
  value = aws_lambda_function.revoke_admin_role.arn
}

output "admin_get_user_arn" {
  value = aws_lambda_function.admin_get_user.arn
}

output "admin_update_user_arn" {
  value = aws_lambda_function.admin_update_user.arn
}

output "admin_delete_user_arn" {
  value = aws_lambda_function.admin_delete_user.arn
}