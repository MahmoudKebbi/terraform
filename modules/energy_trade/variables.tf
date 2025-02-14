variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  type        = string
}

variable "region"{ 
    type = string
    description = "The region in which the resources are created"
}

variable "cognito_user_pool_client_id"{
    type = string
    description = "The ID of the Cognito User Pool Client"
}
