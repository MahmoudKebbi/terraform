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

  # Additional attributes
  dynamic "attribute" {
    for_each = var.additional_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Add Global Secondary Indexes
  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "email"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "NameIndex"
    hash_key        = "username"
    projection_type = "ALL"
  }

  # Add server-side encryption
  server_side_encryption {
    enabled = var.server_side_encryption_enabled
  }

  tags = var.tags
}