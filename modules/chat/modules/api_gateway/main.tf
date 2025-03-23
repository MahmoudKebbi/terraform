resource "aws_api_gateway_rest_api" "this" {
  name = var.rest_api_name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  type        = "HTTP_PROXY"
  uri         = var.ecs_service_url
  connection_type = "VPC_LINK"
  connection_id   = var.vpc_endpoint_id
  credentials    = var.execute_role_arn
}

resource "aws_api_gateway_authorizer" "this" {
  name        = "cognito-authorizer"
  rest_api_id = aws_api_gateway_rest_api.this.id
  type        = "COGNITO_USER_POOLS"
  provider_arns = [
    var.user_pool_arn
  ]
}
