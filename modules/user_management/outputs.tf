output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "user_pool_client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = module.cognito.user_pool_client_id
}

output "user_pool_arn" {
  description = "The ID of the Cognito User Pool Client"
  value       = module.cognito.user_pool_arn
}

output "aws_api_gateway_deployment_arn" {
  description = "The ARN of the API Gateway deployment"
  value       = module.apigateway.aws_api_gateway_deployment_arn
}

output "aws_api_gateway_authorizer_id" {
  description = "The ID of the API Gateway Authorizer"
  value       = module.apigateway.aws_api_gateway_authorizer_id
}

output "aws_api_gateway_rest_api_id"{
  description = "The ID of the API Gateway REST API"
  value       = module.apigateway.aws_api_gateway_rest_api_id
}

output "aws_api_gateway_version_resource_id"{
  description = "The ID of the API Gateway Resource"
  value       = module.apigateway.aws_api_gateway_version_resource_id
}