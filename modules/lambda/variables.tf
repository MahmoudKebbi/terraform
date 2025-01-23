variable "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution IAM role"
  type        = string
}

variable "users_table_name" {
  description = "Name of the Users DynamoDB table"
  type        = string
}

variable "transactions_table_name" {
  description = "Name of the Transactions DynamoDB table"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}