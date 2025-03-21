variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "eu-west-1"
}

variable "repository_name" {
  description = "The name of the ECR repository"
  default     = "my-api-repo"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  default     = "my-ecs-cluster"
}

variable "service_name" {
  description = "The name of the ECS service"
  default     = "my-ecs-service"
}

variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  default     = "my-user-pool"
}

variable "app_client_name" {
  description = "The name of the Cognito App Client"
  default     = "my-app-client"
}

variable "rest_api_name" {
  description = "The name of the API Gateway REST API"
  default     = "my-api"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  default     = "Equilux_Messages"
}

variable "dynamodb_partition_key" {
  description = "The partition key of the DynamoDB table"
  default     = "conversationId"
}

variable "dynamodb_sort_key" {
  description = "The sort key of the DynamoDB table"
  default     = "timestamp"
}

variable "dynamodb_gsi1_partition_key" {
  description = "The partition key of the GSI1"
  default     = "senderId"
}

variable "dynamodb_gsi1_sort_key" {
  description = "The sort key of the GSI1"
  default     = "timestamp"
}

variable "dynamodb_gsi2_partition_key" {
  description = "The partition key of the GSI2"
  default     = "receiverId"
}

variable "dynamodb_gsi2_sort_key" {
  description = "The sort key of the GSI2"
  default     = "timestamp"
}