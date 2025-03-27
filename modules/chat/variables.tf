variable "region" {
  description = "The AWS region to deploy to"
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "user_pool_arn"{
  description = "The ID of the Cognito User Pool"
}

variable "user_pool_id"{
  description = "The ID of the Cognito User Pool"
}

variable "repository_name" {
  description = "The name of the ECR repository"
  default     = "equilux-chat-repo"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  default     = "equilux-chat-cluster"
}

variable "service_name" {
  description = "The name of the ECS service"
  default     = "equilux-chat-service"
}

variable "rest_api_name" {
  description = "The name of the API Gateway REST API"
  default     = "equilux-chat-api"
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

variable "project_name" {
  description = "The name of the project"
  default     = "equilux-chat-service"
}

variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}