#############################################
################User Management##############
#############################################
resource "aws_dynamodb_table" "user_table" {
  name           = var.users_table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  attribute {
    name = "first_name"
    type = "S"
  }

  attribute {
    name = "last_name"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "phone_number"
    type = "S"
  }

  attribute {
    name = "landline"
    type = "S"
  }

  attribute {
    name = "street"
    type = "S"
  }

  attribute {
    name = "city"
    type = "S"
  }

  attribute {
    name = "province_state"
    type = "S"
  }

  attribute {
    name = "building"
    type = "S"
  }

  attribute {
    name = "floor"
    type = "N"
  }

  attribute {
    name = "apartment"
    type = "S"
  }

  attribute {
    name = "web_3_wallet_address"
    type = "S"
  }

  # Add server-side encryption
  server_side_encryption {
    enabled = var.server_side_encryption_enabled
  }

  tags = var.tags

  global_secondary_index {
    name               = "email-index"
    hash_key           = "email"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "phone_number-index"
    hash_key           = "phone_number"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "web_3_wallet_address-index"
    hash_key           = "web_3_wallet_address"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "first_name-index"
    hash_key           = "first_name"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "last_name-index"
    hash_key           = "last_name"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "landline-index"
    hash_key           = "landline"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "street-index"
    hash_key           = "street"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "city-index"
    hash_key           = "city"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "province_state-index"
    hash_key           = "province_state"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "building-index"
    hash_key           = "building"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "floor-index"
    hash_key           = "floor"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "apartment-index"
    hash_key           = "apartment"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}