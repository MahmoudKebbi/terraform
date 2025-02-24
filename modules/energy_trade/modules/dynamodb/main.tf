
# Table to store trade records.
resource "aws_dynamodb_table" "trades" {
  name           = "Equilux_Energy_Trades"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "transaction_hash"

  attribute {
    name = "transaction_hash"
    type = "S"
  }

  attribute {
    name = "buyer_username"
    type = "S"
  }

  attribute {
    name = "seller_username"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  attribute {
    name = "time"
    type = "S"
  }
  
  attribute {
    name = "amount"
    type = "S"
  }

  attribute {
    name = "price_per_kwh"
    type = "S"
  }

  attribute {
    name = "block_number"
    type = "S"
  }

  global_secondary_index {
    name            = "buyer_username-index"
    hash_key        = "p1_username"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "seller_username"
    hash_key        = "seller_username"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "date-index"
    hash_key        = "date"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "time-index"
    hash_key        = "time"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "block_number-index"
    hash_key        = "block_number"
    projection_type = "ALL"
  }

  global_secondary_index {
    name           = "amount-index"
    hash_key       = "amount"
    projection_type = "ALL"
  }

  global_secondary_index {
    name           = "price_per_kwh-index"
    hash_key       = "price_per_kwh"
    projection_type = "ALL"
  }
    server_side_encryption {
    enabled = var.server_side_encryption_enabled
  }
}


# Table to store active WebSocket connection IDs.
resource "aws_dynamodb_table" "ws_connections" {
  name           = "Equilux_WebSockets_Connections"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }
}
