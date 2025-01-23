output "lambda_log_group_names" {
  description = "Names of Lambda function log groups"
  value = concat(
    [for log_group in aws_cloudwatch_log_group.lambda_user_log_groups : log_group.name],
    [for log_group in aws_cloudwatch_log_group.lambda_transaction_log_groups : log_group.name]
  )
}

output "alarm_names" {
  description = "Names of CloudWatch alarms"
  value = concat(
    [for alarm in aws_cloudwatch_metric_alarm.lambda_user_error_alarm : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.lambda_transaction_error_alarm : alarm.alarm_name],
    [
      aws_cloudwatch_metric_alarm.api_gateway_4xx_errors.alarm_name,
      aws_cloudwatch_metric_alarm.api_gateway_5xx_errors.alarm_name
    ]
  )
}