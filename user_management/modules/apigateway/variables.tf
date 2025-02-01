#############################################
################User Management##############
#############################################
variable "user_management_lambda_functions" {
  description = "List of Lambda functions ARNs"
  type        = map(string)
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  type        = string
}