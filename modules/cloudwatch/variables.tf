variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "lambda_error_threshold" {
  description = "Threshold for Lambda function errors before triggering an alarm"
  type        = number
  default     = 1
}

variable "api_4xx_error_threshold" {
  description = "Threshold for API Gateway 4XX errors before triggering an alarm"
  type        = number
  default     = 10
}

variable "api_5xx_error_threshold" {
  description = "Threshold for API Gateway 5XX errors before triggering an alarm"
  type        = number
  default     = 5
}

variable "alarm_notification_arns" {
  description = "List of ARNs to notify when an alarm is triggered"
  type        = list(string)
  default     = []
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}