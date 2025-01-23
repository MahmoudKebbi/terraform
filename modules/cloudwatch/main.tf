# CloudWatch Log Groups for Lambda Functions
resource "aws_cloudwatch_log_group" "lambda_user_log_groups" {
  for_each = toset(["create", "get", "update", "delete"])

  name              = "/aws/lambda/user_${each.key}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "lambda_transaction_log_groups" {
  for_each = toset(["record", "get", "update", "delete"])

  name              = "/aws/lambda/transaction_${each.key}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/api-gateway/energy_platform_api"
  retention_in_days = var.log_retention_days
}

# CloudWatch Alarms for Lambda Error Rates
resource "aws_cloudwatch_metric_alarm" "lambda_user_error_alarm" {
  for_each = toset(["create", "get", "update", "delete"])

  alarm_name          = "user-${each.key}-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.lambda_error_threshold

  dimensions = {
    FunctionName = "user_${each.key}"
  }

  alarm_description = "This metric monitors user ${each.key} lambda function errors"
  alarm_actions     = var.alarm_notification_arns
}

resource "aws_cloudwatch_metric_alarm" "lambda_transaction_error_alarm" {
  for_each = toset(["record", "get", "update", "delete"])

  alarm_name          = "transaction-${each.key}-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.lambda_error_threshold

  dimensions = {
    FunctionName = "transaction_${each.key}"
  }

  alarm_description = "This metric monitors transaction ${each.key} lambda function errors"
  alarm_actions     = var.alarm_notification_arns
}

# Additional CloudWatch Alarms for Lambda Metrics
resource "aws_cloudwatch_metric_alarm" "lambda_user_duration_alarm" {
  for_each = toset(["create", "get", "update", "delete"])

  alarm_name          = "user-${each.key}-high-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = var.lambda_duration_threshold

  dimensions = {
    FunctionName = "user_${each.key}"
  }

  alarm_description = "This metric monitors user ${each.key} lambda function duration"
  alarm_actions     = var.alarm_notification_arns
}

resource "aws_cloudwatch_metric_alarm" "lambda_transaction_duration_alarm" {
  for_each = toset(["record", "get", "update", "delete"])

  alarm_name          = "transaction-${each.key}-high-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = var.lambda_duration_threshold

  dimensions = {
    FunctionName = "transaction_${each.key}"
  }

  alarm_description = "This metric monitors transaction ${each.key} lambda function duration"
  alarm_actions     = var.alarm_notification_arns
}

# API Gateway Metrics Alarms
resource "aws_cloudwatch_metric_alarm" "api_gateway_4xx_errors" {
  alarm_name          = "api-gateway-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.api_4xx_error_threshold

  dimensions = {
    ApiName = var.api_name
  }

  alarm_description = "This metric monitors API Gateway 4XX errors"
  alarm_actions     = var.alarm_notification_arns
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_errors" {
  alarm_name          = "api-gateway-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.api_5xx_error_threshold

  dimensions = {
    ApiName = var.api_name
  }

  alarm_description = "This metric monitors API Gateway 5XX errors"
  alarm_actions     = var.alarm_notification_arns
}