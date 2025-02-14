#############################################
################User Management##############
#############################################
output "user_api_url" {
  description = "The URL of the API Gateway"
  value       = "${aws_api_gateway_rest_api.this.execution_arn}/prod"
}

output "aws_api_gateway_deployment_arn" {
  description = "The ARN of the API Gateway deployment"
  value       = aws_api_gateway_deployment.this.execution_arn
}

output "aws_api_gateway_rest_api_id"{
  description = "The ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "aws_api_gateway_authorizer_id" {
  description = "The ID of the API Gateway Authorizer"
  value       = aws_api_gateway_authorizer.cognito_authorizer.id
}

output "aws_api_gateway_version_resource_id"{
  description = "The ID of the API Gateway Resource"
  value       = aws_api_gateway_resource.v1.id
}