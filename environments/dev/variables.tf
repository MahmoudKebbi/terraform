# AWS Region Configuration
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

# Environment Specific Variables
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of dev, staging, or prod."
  }
}

# DynamoDB Table Configuration
variable "users_table_name" {
  description = "Name of the Users DynamoDB table"
  type        = string
  default     = "dev-energy-users"
}

variable "transactions_table_name" {
  description = "Name of the Transactions DynamoDB table"
  type        = string
  default     = "dev-energy-transactions"
}

# Security Configuration
variable "blocked_ip_list" {
  description = "List of IP addresses to block in the development environment"
  type        = list(string)
  default     = []
}

variable "rate_limit" {
  description = "Maximum number of requests allowed from a single IP in 5 minutes for dev environment"
  type        = number
  default     = 1000
}

# Logging and Monitoring
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs in development"
  type        = number
  default     = 14
}

# Tagging
variable "tags" {
  description = "Additional tags for development resources"
  type        = map(string)
  default = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    Project     = "Energy Platform"
  }
}

# Optional IAM Role Assumption
variable "assume_role_arn" {
  description = "Optional IAM role ARN to assume during deployment"
  type        = string
  default     = null
}

# Alarm Notifications
variable "alarm_notification_arns" {
  description = "List of ARNs to notify when an alarm is triggered in development"
  type        = list(string)
  default     = []
}

# Lambda Configuration
variable "lambda_memory_size" {
  description = "Amount of memory available to Lambda functions in development"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "Maximum execution time for Lambda functions in development"
  type        = number
  default     = 10
}

# Optional Feature Flags
variable "enable_detailed_monitoring" {
  description = "Enable additional detailed monitoring in development"
  type        = bool
  default     = true
}

variable "enable_debugging" {
  description = "Enable additional debugging features"
  type        = bool
  default     = true
}