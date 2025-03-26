variable "cluster_name" {
  description = "The name of the ECS cluster"
}

variable "service_name" {
  description = "The name of the ECS service"
}

variable "container_image" {
  description = "The container image for the ECS service"
}

variable "subnets" {
  description = "The subnets for the ECS service"
  type        = list(string)
}

variable "security_groups" {
  description = "The security groups for the ECS service"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID for the ECS service"
}

variable "table_name" {
  description = "The name of the DynamoDB table"
}