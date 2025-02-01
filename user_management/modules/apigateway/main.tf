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

resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{user_id}"
}

# Define the error response model
resource "aws_api_gateway_model" "error_response" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "ErrorResponse"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object",
  "properties": {
    "message": { "type": "string" },
    "code": { "type": "string" }
  },
  "required": ["message", "code"]
}
EOF
}

# Define the request model for creating a user with validation constraints
resource "aws_api_gateway_model" "create_user_request" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "CreateUserRequest"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object",
  "properties": {
    "username": {
      "type": "string",
      "pattern": "^[A-Za-z][A-Za-z0-9_]{3,}$",
      "minLength": 4,
      "description": "Username must start with a letter and be at least 4 characters long"
    },
    "first_name": {
      "type": "string",
      "pattern": "^[A-Za-z]+$",
      "minLength": 2,
      "description": "First name must contain only letters and be at least 2 characters long"
    },
    "last_name": {
      "type": "string",
      "pattern": "^[A-Za-z]+$",
      "minLength": 2,
      "description": "Last name must contain only letters and be at least 2 characters long"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "Must be a valid email format"
    },
    "phone_number": {
      "type": "string",
      "pattern": "^[+]?[(]?[0-9]{1,4}[)]?[-\\s./0-9]*$",
      "description": "Must be a valid phone number format"
    },
    "landline": {
      "type": ["string", "null"],
      "pattern": "^[+]?[(]?[0-9]{1,4}[)]?[-\\s./0-9]*$",
      "description": "Must be a valid phone number format"
    },
    "street": {
      "type": "string",
      "minLength": 1,
      "description": "Street must be a non-empty string"
    },
    "city": {
      "type": "string",
      "minLength": 1,
      "description": "City must be a non-empty string"
    },
    "province_state": {
      "type": "string",
      "minLength": 1,
      "description": "Province/State must be a non-empty string"
    },
    "building": {
      "type": ["string", "null"],
      "description": "Building can be a string"
    },
    "floor": {
      "type": ["string", "number" , "null"],
      "description": "Floor can be a string or number"
    },
    "apartment": {
      "type": ["string", "number", "null"],
      "description": "Apartment can be a string or number"
    }
  },
  "required": ["username", "first_name", "last_name", "email", "phone_number", "street", "city", "province_state"]
}
EOF
}

# Define the request model for getting a user with validation constraints
resource "aws_api_gateway_model" "get_user_request" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "GetUserRequest"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object",
  "properties": {
    "username": {
      "type": "string",
      "pattern": "^[A-Za-z][A-Za-z0-9_]{3,}$",
      "minLength": 4,
      "description": "Username must start with a letter and be at least 4 characters long"
    }
  },
  "required": ["username"]
}
EOF
}

# Define the request model for updating a user with validation constraints
resource "aws_api_gateway_model" "update_user_request" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "UpdateUserRequest"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object",
  "properties": {
    "first_name": {
      "type": "string",
      "pattern": "^[A-Za-z]+$",
      "minLength": 2,
      "description": "First name must contain only letters and be at least 2 characters long"
    },
    "last_name": {
      "type": "string",
      "pattern": "^[A-Za-z]+$",
      "minLength": 2,
      "description": "Last name must contain only letters and be at least 2 characters long"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "Must be a valid email format"
    },
    "phone_number": {
      "type": "string",
      "pattern": "^[+]?[(]?[0-9]{1,4}[)]?[-\\s./0-9]*$",
      "description": "Must be a valid phone number format"
    },
    "landline": {
      "type": ["string", "null"],
      "pattern": "^[+]?[(]?[0-9]{1,4}[)]?[-\\s./0-9]*$",
      "description": "Must be a valid phone number format"
    },
    "street": {
      "type": "string",
      "minLength": 1,
      "description": "Street must be a non-empty string"
    },
    "city": {
      "type": "string",
      "minLength": 1,
      "description": "City must be a non-empty string"
    },
    "province_state": {
      "type": "string",
      "minLength": 1,
      "description": "Province/State must be a non-empty string"
    },
    "building": {
      "type": ["string", "null"],
      "description": "Building can be a string"
    },
    "floor": {
      "type": ["string", "number", "null"],
      "description": "Floor can be a string or number"
    },
    "apartment": {
      "type": ["string", "number", "null"],
      "description": "Apartment can be a string or number"
    }
  }
}
EOF
}

# Define the request model for deleting a user with validation constraints
resource "aws_api_gateway_model" "delete_user_request" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "DeleteUserRequest"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object",
  "properties": {
    "username": {
      "type": "string",
      "pattern": "^[A-Za-z][A-Za-z0-9_]{3,}$",
      "minLength": 4,
      "description": "Username must start with a letter and be at least 4 characters long"
    }
  },
  "required": ["username"]
}
EOF
}

# Define the response model for user operations
resource "aws_api_gateway_model" "user_response" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "UserResponse"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object",
  "properties": {
    "id": { "type": "string" },
    "username": { "type": "string" },
    "first_name": { "type": "string" },
    "last_name": { "type": "string" },
    "email": { "type": "string" },
    "phone_number": { "type": "string" },
    "landline": { "type": ["string", "null"] },
    "street": { "type": "string" },
    "city": { "type": "string" },
    "province_state": { "type": "string" },
    "building": { "type": ["string", "null"] },
    "floor": { "type": ["string", "number", "null"] },
    "apartment": { "type": ["string", "number", "null"] }
  },
  "required": ["id", "username", "first_name", "last_name", "email", "phone_number", "street", "city", "province_state"]
}
EOF
}

# Create User Method
resource "aws_api_gateway_method" "create_user" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_models = {
    "application/json" = aws_api_gateway_model.create_user_request.name
  }
  depends_on = [aws_api_gateway_model.create_user_request]
}

resource "aws_api_gateway_integration" "create_user" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.create_user.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.user_management_lambda_functions.create_user}/invocations"
}

resource "aws_api_gateway_method_response" "create_user_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.create_user.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.user_response.name
  }
}

resource "aws_api_gateway_method_response" "create_user_400" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.create_user.http_method
  status_code = "400"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_method_response" "create_user_500" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.create_user.http_method
  status_code = "500"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "create_user_200" {
  depends_on = [aws_api_gateway_integration.create_user]
  http_method = aws_api_gateway_method.create_user.http_method
  status_code = "200"
  response_templates = {
    "application/json" = "{\"message\": \"User created successfully\", \"code\": \"200\"}"
  }
}

resource "aws_api_gateway_integration_response" "create_user_400" {
  depends_on = [aws_api_gateway_integration.create_user]
  http_method = aws_api_gateway_method.create_user.http_method
  status_code = "400"
  selection_pattern = ".*\\[BadRequest\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Bad Request\", \"code\": \"400\"}"
  }
}

resource "aws_api_gateway_integration_response" "create_user_500" {
  depends_on = [aws_api_gateway_integration.create_user]
  http_method = aws_api_gateway_method.create_user.http_method
  status_code = "500"
  selection_pattern = ".*\\[InternalServerError\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Internal Server Error\", \"code\": \"500\"}"
  }
}

# Get User Method
resource "aws_api_gateway_method" "get_user" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
    "method.request.path.user_id" = true
  }

  request_models = {
    "application/json" = aws_api_gateway_model.get_user_request.name
  }
  depends_on = [aws_api_gateway_model.get_user_request]
}

resource "aws_api_gateway_integration" "get_user" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.user_management_lambda_functions.get_user}/invocations"
}

resource "aws_api_gateway_method_response" "get_user_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.user_response.name
  }
}

resource "aws_api_gateway_method_response" "get_user_400" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "400"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_method_response" "get_user_500" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "500"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "get_user_200" {
  depends_on = [aws_api_gateway_integration.get_user]
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "200"
  response_templates = {
    "application/json" = "{\"message\": \"User retrieved successfully\", \"code\": \"200\"}"
  }
}

resource "aws_api_gateway_integration_response" "get_user_400" {
  depends_on = [aws_api_gateway_integration.get_user]
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "400"
  selection_pattern = ".*\\[BadRequest\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Bad Request\", \"code\": \"400\"}"
  }
}

resource "aws_api_gateway_integration_response" "get_user_500" {
  depends_on = [aws_api_gateway_integration.get_user]
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "500"
  selection_pattern = ".*\\[InternalServerError\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Internal Server Error\", \"code\": \"500\"}"
  }
}

# Update User Method
resource "aws_api_gateway_method" "update_user" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
    "method.request.path.user_id" = true
  }

  request_models = {
    "application/json" = aws_api_gateway_model.update_user_request.name
  }
  depends_on = [aws_api_gateway_model.update_user_request]
}

resource "aws_api_gateway_integration" "update_user" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.update_user.http_method
  type        = "AWS_PROXY"
  integration_http_method = "PUT"
  uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.user_management_lambda_functions.update_user}/invocations"
}

resource "aws_api_gateway_method_response" "update_user_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.update_user.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.user_response.name
  }
}

resource "aws_api_gateway_method_response" "update_user_400" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.update_user.http_method
  status_code = "400"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_method_response" "update_user_500" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.update_user.http_method
  status_code = "500"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "update_user_200" {
  depends_on = [aws_api_gateway_integration.update_user]
  http_method = aws_api_gateway_method.update_user.http_method
  status_code = "200"
  response_templates = {
    "application/json" = "{\"message\": \"User updated successfully\", \"code\": \"200\"}"
  }
}

resource "aws_api_gateway_integration_response" "update_user_400" {
  depends_on = [aws_api_gateway_integration.update_user]
  http_method = aws_api_gateway_method.update_user.http_method
  status_code = "400"
  selection_pattern = ".*\\[BadRequest\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Bad Request\", \"code\": \"400\"}"
  }
}

resource "aws_api_gateway_integration_response" "update_user_500" {
  depends_on = [aws_api_gateway_integration.update_user]
  http_method = aws_api_gateway_method.update_user.http_method
  status_code = "500"
  selection_pattern = ".*\\[InternalServerError\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Internal Server Error\", \"code\": \"500\"}"
  }
}

# Delete User Method
resource "aws_api_gateway_method" "delete_user" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
    "method.request.path.user_id" = true
  }

  request_models = {
    "application/json" = aws_api_gateway_model.delete_user_request.name
  }
  depends_on = [aws_api_gateway_model.delete_user_request]
}

resource "aws_api_gateway_integration" "delete_user" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.delete_user.http_method
  type        = "AWS_PROXY"
  integration_http_method = "DELETE"
  uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.user_management_lambda_functions.delete_user}/invocations"
}

resource "aws_api_gateway_method_response" "delete_user_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.delete_user.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.user_response.name
  }
}

resource "aws_api_gateway_method_response" "delete_user_400" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.delete_user.http_method
  status_code = "400"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_method_response" "delete_user_500" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.delete_user.http_method
  status_code = "500"

  response_models = {
    "application/json" = aws_api_gateway_model.error_response.name
  }

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_user_200" {
  depends_on = [aws_api_gateway_integration.delete_user]
  http_method = aws_api_gateway_method.delete_user.http_method
  status_code = "200"
  response_templates = {
    "application/json" = "{\"message\": \"User deleted successfully\", \"code\": \"200\"}"
  }
}

resource "aws_api_gateway_integration_response" "delete_user_400" {
  depends_on = [aws_api_gateway_integration.delete_user]
  http_method = aws_api_gateway_method.delete_user.http_method
  status_code = "400"
  selection_pattern = ".*\\[BadRequest\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Bad Request\", \"code\": \"400\"}"
  }
}

resource "aws_api_gateway_integration_response" "delete_user_500" {
  depends_on = [aws_api_gateway_integration.delete_user]
  http_method = aws_api_gateway_method.delete_user.http_method
  status_code = "500"
  selection_pattern = ".*\\[InternalServerError\\].*"
  response_templates = {
    "application/json" = "{\"message\": \"Internal Server Error\", \"code\": \"500\"}"
  }
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name             = "CognitoAuthorizer"
  rest_api_id      = aws_api_gateway_rest_api.this.id
  authorizer_uri   = "arn:aws:apigateway:${var.region}:cognito-idp:aws:action/cognito-idp:authorize"
  identity_source  = "method.request.header.Authorization"
  type             = "COGNITO_USER_POOLS"
  provider_arns    = [var.cognito_user_pool_arn]
}

# Enable logging for API Gateway
resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/api-gateway/UserManagementAPI"
  retention_in_days = 14
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.create_user,
    aws_api_gateway_integration.get_user,
    aws_api_gateway_integration.update_user,
    aws_api_gateway_integration.delete_user
  ]

  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "dev"
}
