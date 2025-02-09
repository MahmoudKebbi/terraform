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

variable "aws_api_gateway_rest_api_id" {
  description = "ID of the API Gateway REST API"
  type        = string
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

variable "list_all_users_arn"{
  description = "ARN of the Lambda function to list all users"
  type        = string
}

variable "assign_admin_role_arn"{
  description = "ARN of the Lambda function to assign an admin role"
  type        = string
}

variable "revoke_admin_role_arn"{
  description = "ARN of the Lambda function to revoke an admin role"
  type        = string
}

variable "admin_get_user_arn"{
  description = "ARN of the Lambda function to get a user as an admin"
  type        = string
}

variable "admin_update_user_arn"{
  description = "ARN of the Lambda function to update a user as an admin"
  type        = string
}

variable "admin_delete_user_arn"{
  description = "ARN of the Lambda function to delete a user as an admin"
  type        = string
}
