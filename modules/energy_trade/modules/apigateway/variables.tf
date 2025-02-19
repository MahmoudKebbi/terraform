variable "aws_iam_role_lambda_admin_role_arn"{
    type = string
    description = "The ARN of the IAM Role for the Lambda Admin Role"
}

variable "aws_iam_role_lambda_user_role_arn"{
    type = string
    description = "The ARN of the IAM Role for the Lambda User Role"
}

variable "aws_lambda_function_trade_invoke_arn"{
    type = string
    description = "The ARN of the Lambda Function for Get Trade History"
}

variable "aws_lambda_function_trade_admin_invoke_arn"{
    type = string
    description = "The ARN of the Lambda Function for Get Trade History Admin"
}

variable "aws_lambda_function_ws_handler_invoke_arn"{
    type = string
    description = "The ARN of the Lambda Function for WebSocket Handler"
}


variable "aws_lambda_function_ws_handler_function_name"{
    type = string
    description = "The name of the Lambda Function for WebSocket Handler"
}

variable "user_pool_arn"{
    type = string
    description = "The ARN of the Cognito User Pool"
}

variable "cognito_user_pool_client_id"{
    type = string
    description = "The ID of the Cognito User Pool Client"
}

variable "region"{
    type = string
    description = "The region in which the resources are created"
}

variable "apigateway_user_role_arn"{
    type = string
    description = "The ARN of the IAM Role for the API Gateway User Role"
}

variable "apigateway_admin_role_arn"{
    type = string
    description = "The ARN of the IAM Role for the API Gateway Admin Role"
}

variable "ws_authorizer_lambda_arn"{
    type = string
    description = "The ARN of the Lambda Function for WebSocket Authorizer"
}