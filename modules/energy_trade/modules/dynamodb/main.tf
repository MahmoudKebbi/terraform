
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
    name = "p1_user_id"
    type = "S"
  }

  attribute {
    name = "p2_user_id"
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
    name = "block_number"
    type = "S"
  }

  global_secondary_index {
    name            = "p1_user_id-index"
    hash_key        = "p1_user_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "p2_user_id-index"
    hash_key        = "p2_user_id"
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
