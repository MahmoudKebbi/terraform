variable "rest_api_name" {
  description = "The name of the API Gateway REST API"
}

variable "user_pool_id" {
  description = "The ID of the Cognito User Pool"
}

variable "app_client_id" {
  description = "The ID of the Cognito App Client"
}

variable "ecs_service_url" {
  description = "The URL of the ECS service"
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint"
}