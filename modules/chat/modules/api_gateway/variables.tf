variable "rest_api_name" {
  description = "The name of the API Gateway REST API"
}

variable "user_pool_arn" {
  description = "The ID of the Cognito User Pool"
}

variable "ecs_service_url" {
  description = "The URL of the ECS service"
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint"
}

variable "execute_role_arn" {
  description = "The ARN of the IAM role for API Gateway execution"
}