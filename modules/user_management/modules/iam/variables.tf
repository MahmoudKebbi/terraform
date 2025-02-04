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

variable "user_pool_id" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "user-pool"
}

variable "post_confirmation_arn" {
  description = "ARN of the Lambda function to be invoked after user confirmation"
  type        = string
  default     = "arn:aws:lambda:us-west-2:123456789012:function:post_confirmation"
}

variable "delete_user_arn"{
  description = "ARN of the Lambda function to delete a user"
  type        = string
}

variable "create_user_arn"{
  description = "ARN of the Lambda function to create a user"
  type        = string
}

variable "get_user_arn"{
  description = "ARN of the Lambda function to get a user"
  type        = string
}

variable "update_user_arn"{
  description = "ARN of the Lambda function to update a user"
  type        = string
}