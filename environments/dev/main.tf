# Provider configuration specific to the development environment
provider "aws" {
  region = "us-east-1"

  default_tags {
    Environment = "Development"
  }
}

# Local values for development-specific configurations
locals {
  environment_name = "dev"
  
  # Development-specific tags
  common_tags = {
    Environment = "Development"
    Project     = "Energy Platform"
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering"
  }

  # Optional: Development-specific IP restrictions
  blocked_ip_list = []

  # Notification email or SNS topic for alarms
  alarm_notification_arns = []
}

# Main module for the Energy Platform
module "energy_platform" {
  source = "../.."  # Reference to the root module

  # Environment-specific variable overrides
  environment = local.environment_name

  # DynamoDB Table Configurations
  users_table_name         = "dev-energy-users"
  transactions_table_name  = "dev-energy-transactions"

  # Security Configurations
  blocked_ip_list = local.blocked_ip_list
  rate_limit      = 1000  # More restrictive for development

  # Tags to apply across all resources
  tags = local.common_tags

  # Optional: Alarm notification configurations
  alarm_notification_arns = local.alarm_notification_arns
}

# Optional: Development-specific outputs
output "dev_environment_info" {
  description = "Development environment specific information"
  value = {
    environment_name     = local.environment_name
    users_table_name     = module.energy_platform.users_table_name
    transactions_table_name = module.energy_platform.transactions_table_name
    api_gateway_name     = module.energy_platform.api_name
  }
}