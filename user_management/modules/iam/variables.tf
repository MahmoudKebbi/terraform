#############################################
################User Management##############
#############################################
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "user_dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "users"
}

variable "user_pool_arn" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "user-pool"
}

variable "post_confirmation_arn" {
  description = "ARN of the Lambda function to be invoked after user confirmation"
  type        = string
  default     = "arn:aws:lambda:us-west-2:123456789012:function:post_confirmation"
}