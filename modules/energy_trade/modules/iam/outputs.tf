output "aws_iam_role_lambda_user_role_arn"{
    value = aws_iam_role.lambda_user_role.arn
}

output "aws_iam_role_lambda_admin_role_arn"{
    value = aws_iam_role.lambda_admin_role.arn
}

output "aws_iam_role_lambda_ws_role_arn"{
    value = aws_iam_role.lambda_ws_role.arn
}