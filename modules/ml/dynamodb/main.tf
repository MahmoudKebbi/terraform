resource "aws_dynamodb_table" "user_consumption" {
  name           = "user_consumption"
  billing_mode   = var.billing_mode
  hash_key       = "user_id"

  attribute {
    name = "user_id"
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
    name = "consumption"
    type = "S"
  }

  global_secondary_index {
    name               = "date-index"
    hash_key           = "date"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "consumption-index"
    hash_key           = "consumption"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "time-index"
    hash_key           = "time"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

# Add server-side encryption
  server_side_encryption {
    enabled = var.server_side_encryption_enabled
  }

  tags = var.tags
}

#############################################
################User Management##############
#############################################
resource "aws_dynamodb_table" "user_production" {
  name           = "user_consumption"
  billing_mode   = var.billing_mode
  hash_key       = "user_id"

  attribute {
    name = "user_id"
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
    name = "production"
    type = "S"
  }

  global_secondary_index {
    name               = "date-index"
    hash_key           = "date"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "production-index"
    hash_key           = "production"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "time-index"
    hash_key           = "time"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

# Add server-side encryption
  server_side_encryption {
    enabled = var.server_side_encryption_enabled
  }

  tags = var.tags
}

