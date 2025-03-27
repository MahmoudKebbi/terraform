variable "name_prefix" {
  description = "Prefix to use for resource names"
  type        = string
}

variable "docker_image" {
  description = "URI of the Docker image"
  type        = string
}

variable "user_pool_id" {
  description = "ID of the Cognito user pool"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for App Runner"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for App Runner"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the IAM role for App Runner tasks"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for App Runner execution"
  type        = string
}

variable "cpu" {
  description = "CPU units for App Runner (0.25, 0.5, 1, 2, or 4 vCPU)"
  type        = string
  default     = "0.25"
}

variable "memory" {
  description = "Memory for App Runner (0.5, 1, 2, 3, 4 GB)"
  type        = string
  default     = "0.5"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}