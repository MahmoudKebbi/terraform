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