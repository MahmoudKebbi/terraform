resource "aws_api_gateway_rest_api" "energy_platform_api" {
  name        = "Energy Platform API"
  description = "API for User and Transaction Management"
}

# User API Resources
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.energy_platform_api.id
  parent_id   = aws_api_gateway_rest_api.energy_platform_api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_method" "user_methods" {
  for_each = toset(["POST", "GET", "PUT", "DELETE"])

  rest_api_id   = aws_api_gateway_rest_api.energy_platform_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = each.key
  authorization = "IAM"
}

resource "aws_api_gateway_integration" "user_integration" {
  for_each = toset(["create", "get", "update", "delete"])

  rest_api_id = aws_api_gateway_rest_api.energy_platform_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.user_methods[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.user_functions[each.key].invoke_arn
}

# Transaction API Resources
resource "aws_api_gateway_resource" "transactions" {
  rest_api_id = aws_api_gateway_rest_api.energy_platform_api.id
  parent_id   = aws_api_gateway_rest_api.energy_platform_api.root_resource_id
  path_part   = "transactions"
}

resource "aws_api_gateway_method" "transaction_methods" {
  for_each = toset(["POST", "GET", "PUT", "DELETE"])

  rest_api_id   = aws_api_gateway_rest_api.energy_platform_api.id
  resource_id   = aws_api_gateway_resource.transactions.id
  http_method   = each.key
  authorization = "IAM"
}

resource "aws_api_gateway_integration" "transaction_integration" {
  for_each = toset(["record", "get", "update", "delete"])

  rest_api_id = aws_api_gateway_rest_api.energy_platform_api.id
  resource_id = aws_api_gateway_resource.transactions.id
  http_method = aws_api_gateway_method.transaction_methods[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.transaction_functions[each.key].invoke_arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  for_each = toset(["user_create", "user_get", "user_update", "user_delete", "transaction_record", "transaction_get", "transaction_update", "transaction_delete"])

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.energy_platform_api.execution_arn}/*/*"
}