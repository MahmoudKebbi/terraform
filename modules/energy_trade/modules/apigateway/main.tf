#############################################
################User Management##############
#############################################
resource "aws_api_gateway_rest_api" "this" {
  name        = "UserManagementAPI"
  description = "API for User Management"
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "trades"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "trades"
}

resource "aws_api_gateway_resource" "trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.trades.id
  path_part   = "{trade_id}"
}

resource "aws_api_gateway_resource" "admin"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "admin"
}

resource "aws_api_gateway_resource" "admin_trades"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "trades"
}

resource "aws_api_gateway_resource" "admin_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.admin_trades.id
  path_part   = "{trade_id}"
}

resource "aws_api_gateway_method" "get_trade_history"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.trades.id
  http_method = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
  "method.request.header.Authorization" = true
}

}

resource "aws_api_gateway_integration" "get_trade_history"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.trades.id
  http_method = aws_api_gateway_method.get_trade_history.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = var.aws_iam_role_lambda_user_role_arn
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_trade_invoke_arn}/invocations"
  passthrough_behavior= "WHEN_NO_TEMPLATES"
}


resource "aws_api_gateway_method" "get_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.trade.id
  http_method = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
  "method.request.header.Authorization" = true
}

}

resource "aws_api_gateway_integration" "get_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.trade.id
  http_method = aws_api_gateway_method.get_trade.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = var.aws_iam_role_lambda_user_role_arn
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_trade_invoke_arn}/invocations"
  passthrough_behavior= "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method" "post_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.trade.id
  http_method = "POST"
  authorization= "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
  
  request_parameters={
    "method.request.header.Authorization" = true
  }
}

resource "aws_api_gateway_integration" "post_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.trade.id
  http_method = aws_api_gateway_method.post_trade.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = var.aws_iam_role_lambda_user_role_arn
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_trade_invoke_arn}/invocations"
  passthrough_behavior= "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method" "admin_get_trade_history"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.admin_trades.id
  http_method = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
  "method.request.header.Authorization" = true
}

}

resource "aws_api_gateway_integration" "admin_get_trade_history"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.admin_trades.id
  http_method = aws_api_gateway_method.admin_get_trade_history.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = var.aws_iam_role_lambda_admin_role_arn
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_trade_admin_invoke_arn}/invocations"
  passthrough_behavior= "WHEN_NO_TEMPLATES"
}


resource "aws_api_gateway_method" "admin_get_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.admin_trade.id
  http_method = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
  "method.request.header.Authorization" = true
}

}

resource "aws_api_gateway_integration" "admin_get_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.admin_trade.id
  http_method = aws_api_gateway_method.admin_get_trade.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = var.aws_iam_role_lambda_admin_role_arn
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_trade_admin_invoke_arn}/invocations"
  passthrough_behavior= "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method" "admin_delete_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.admin_trade.id
  http_method = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
  "method.request.header.Authorization" = true
}

}

resource "aws_api_gateway_integration" "admin_delete_trade"{
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.admin_trade.id
  http_method = aws_api_gateway_method.admin_delete_trade.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = var.aws_iam_role_lambda_admin_role_arn
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_trade_admin_invoke_arn}/invocations"
  passthrough_behavior= "WHEN_NO_TEMPLATES"
}

############################
# API Gateway WebSocket API
############################

resource "aws_apigatewayv2_api" "ws_api" {
  name                       = "trade_ws_api"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "ws_integration" {
  api_id             = aws_apigatewayv2_api.ws_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.aws_lambda_function_ws_handler_invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "ws_connect" {
  api_id    = aws_apigatewayv2_api.ws_api.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.ws_integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.ws_jwt_authorizer.id
}

resource "aws_apigatewayv2_route" "ws_disconnect" {
  api_id    = aws_apigatewayv2_api.ws_api.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.ws_integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.ws_jwt_authorizer.id
}

resource "aws_apigatewayv2_route" "ws_default" {
  api_id    = aws_apigatewayv2_api.ws_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.ws_integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.ws_jwt_authorizer.id
}

resource "aws_apigatewayv2_stage" "ws_stage" {
  api_id      = aws_apigatewayv2_api.ws_api.id
  name        = "production"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_ws" {
  statement_id  = "AllowAPIGatewayInvokeWS"
  action        = "lambda:InvokeFunction"
  function_name = var.aws_lambda_function_ws_handler_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.ws_api.execution_arn}/*"
}

resource "aws_apigatewayv2_authorizer" "ws_jwt_authorizer" {
  api_id         = aws_apigatewayv2_api.ws_api.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name            = "WsJwtAuthorizer"

  jwt_configuration {
    audience = [var.cognito_user_pool_client_id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.user_pool_arn}"
  }
}


resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "dev"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name             = "CognitoAuthorizer"
  rest_api_id      = aws_api_gateway_rest_api.this.id
  authorizer_uri   = "arn:aws:apigateway:${var.region}:cognito-idp:aws:action/cognito-idp:authorize"
  identity_source  = "method.request.header.Authorization"
  type             = "COGNITO_USER_POOLS"
  provider_arns    = [var.user_pool_arn]
}