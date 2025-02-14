#############################################
################User Management##############
#############################################
variable "function_prefix" {
  description = "Prefix for the Lambda function names"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "user_management_role_arn" {
  description = "The ARN of the IAM role that Lambda assumes when it executes your function"
  type        = string
}

variable "create_user_filename" {
  description = "The path to the deployment package for the Create User Lambda function"
  type        = string
}

variable "get_user_filename" {
  description = "The path to the deployment package for the Get User Lambda function"
  type        = string
}

variable "update_user_filename" {
  description = "The path to the deployment package for the Update User Lambda function"
  type        = string
}

variable "delete_user_filename" {
  description = "The path to the deployment package for the Delete User Lambda function"
  type        = string
}

variable "post_confirmation_filename" {
  description = "The path to the deployment package for the Post Confirmation Lambda function"
  type        = string
}

variable "list_all_users_filename" {
  description = "The path to the deployment package for the List All Users Lambda function"
  type        = string
}

variable "assign_admin_role_filename" {
  description = "The path to the deployment package for the Assign Admin Role Lambda function"
  type        = string
}

variable "revoke_admin_role_filename" {
  description = "The path to the deployment package for the Revoke Admin Role Lambda function"
  type        = string
}

variable "admin_get_user_filename" {
  description = "The path to the deployment package for the Admin Get User Lambda function"
  type        = string
}

variable "admin_update_user_filename" {
  description = "The path to the deployment package for the Admin Update User Lambda function"
  type        = string
}

variable "admin_delete_user_filename" {
  description = "The path to the deployment package for the Admin Delete User Lambda function"
  type        = string
}

variable "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables to set in the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}
