output "aws_lambda_function_trade_invoke_arn" {
  value = aws_lambda_function.user_trade_handler.invoke_arn
}

output "aws_lambda_function_trade_admin_invoke_arn" {
  value = aws_lambda_function.admin_trade_handler.invoke_arn
}

output "aws_lambda_function_ws_handler_invoke_arn" {
  value = aws_lambda_function.ws_handler.invoke_arn
}

output "aws_lambda_function_ws_handler_function_name"{
    value = aws_lambda_function.ws_handler.function_name
}