variable "aws_dynamodb_table_ws_connections_arn"{
    type = string
    description = "The ARN of the DynamoDB table for WebSocket connections"
}

variable "aws_dynamodb_table_trades_arn"{ 
    type = string
    description = "The ARN of the DynamoDB table for trades"
}

variable "tags"{
    type = map(string)
    description = "A map of tags to add to all resources"
    default = {}
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