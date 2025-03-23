output "api_gateway_url" {
  description = "The URL to invoke the API Gateway"
  value = "${aws_api_gateway_deployment.this.invoke_url}${aws_api_gateway_stage.this.stage_name}"
}

output "api_gateway_arn" {
  description = "The execution ARN for permissions"
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "rest_api_id" {
  description = "The ID of the REST API"
  value = aws_api_gateway_rest_api.this.id
}