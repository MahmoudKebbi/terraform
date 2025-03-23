resource "aws_api_gateway_rest_api" "this" {
  name = var.rest_api_name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_authorizer" "this" {
  name        = "cognito-authorizer"
  rest_api_id = aws_api_gateway_rest_api.this.id
  type        = "COGNITO_USER_POOLS"
  provider_arns = [
    var.user_pool_arn
  ]
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

# Create a VPC Link resource (place this before the integration)
resource "aws_api_gateway_vpc_link" "this" {
  name        = "${var.rest_api_name}-vpclink"
  description = "VPC Link for ${var.rest_api_name}"
  target_arns = [var.nlb_arn]  # Network Load Balancer ARN
}

# Then update your integration to use this VPC Link
resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  type        = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri         = "http://${var.ecs_service_url}"
  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.this.id  # Use the VPC Link, not VPC endpoint
  credentials    = var.execute_role_arn
}

# Add deployment resource
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  
  # Ensure deployment happens after all API resources are created
  depends_on = [
    aws_api_gateway_integration.proxy,
    aws_api_gateway_method.proxy
  ]
  
  # Force new deployment when configuration changes
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_method.proxy.id,
      aws_api_gateway_integration.proxy.id
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Add stage resource
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name != "" ? var.stage_name : "prod"
  
  cache_cluster_enabled = false
  
}
