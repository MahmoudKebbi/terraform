variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of dev, staging, or prod."
  }
}

variable "assume_role_arn" {
  description = "Optional IAM role to assume during deployment"
  type        = string
  default     = null
}

variable "users_table_name" {
  description = "Name of the Users DynamoDB table"
  type        = string
}

variable "transactions_table_name" {
  description = "Name of the Transactions DynamoDB table"
  type        = string
}

variable "alarm_notification_arns" {
  description = "List of ARNs to notify when an alarm is triggered"
  type        = list(string)
  default     = []
}

variable "blocked_ip_list" {
  description = "List of IP addresses to block"
  type        = list(string)
  default     = []
}

variable "rate_limit" {
  description = "Maximum number of requests allowed from a single IP in 5 minutes"
  type        = number
  default     = 2000
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}