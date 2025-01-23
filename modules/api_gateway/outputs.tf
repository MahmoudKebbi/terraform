output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.energy_platform_api.id
}

output "api_root_resource_id" {
  description = "Root resource ID of the API Gateway"
  value       = aws_api_gateway_rest_api.energy_platform_api.root_resource_id
}

output "api_name" {
  description = "Name of the API Gateway"
  value       = aws_api_gateway_rest_api.energy_platform_api.name
}

output "api_gateway_arn" {
  description = "ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.energy_platform_api.arn
}