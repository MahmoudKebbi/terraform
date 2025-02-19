variable "aws_iam_role_lambda_user_role_arn"{
    type = string
    description = "The ARN of the Lambda User Role"
}

variable "aws_iam_role_lambda_admin_role_arn"{
    type = string
    description = "The ARN of the Lambda Admin Role"
}

variable "aws_iam_role_lambda_ws_role_arn"{
    type = string
    description = "The ARN of the Lambda WebSocket Role"
}

variable "aws_dynamodb_table_trades_name"{
    type = string
    description = "The name of the DynamoDB table for trades"
}

variable "aws_dynamodb_table_ws_connections_name"{
    type = string
    description = "The name of the DynamoDB table for WebSocket connections"
}

variable "region"{
    type = string
    description = "The region in which the resources are created"
}

variable "user_trade_handler_filename"{
    type = string
    description = "The filename of the User Trade Handler Lambda"
}

variable "admin_trade_handler_filename"{
    type = string
    description = "The filename of the Admin Trade Handler Lambda"
}

variable "ws_handler_filename"{
    type = string
    description = "The filename of the WebSocket Handler Lambda"
}

variable "tags"{
    type = map(string)
    description = "A map of tags to add to all resources"
    default = {}
}

variable "ws_authorizer_filename"{
    type = string
    description = "The filename of the WebSocket Authorizer Lambda"
}

variable "user_pool_client_id"{
    type = string
    description = "The ARN of the Cognito User Pool"
}

variable "user_pool_id"{
    type = string
    description = "The ID of the Cognito User Pool Client"
}
