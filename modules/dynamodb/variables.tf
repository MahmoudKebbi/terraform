variable "users_table_name" {
  description = "Name of the Users DynamoDB table"
  type        = string
  default     = "Users"
}

variable "transactions_table_name" {
  description = "Name of the Transactions DynamoDB table"
  type        = string
  default     = "Transactions"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}