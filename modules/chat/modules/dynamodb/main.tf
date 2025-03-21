resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = var.partition_key
  range_key = var.sort_key

  attribute {
    name = var.partition_key
    type = "S"
  }

  attribute {
    name = var.sort_key
    type = "S"
  }

  global_secondary_index {
    name            = "GSI1"
    hash_key        = var.gsi1_partition_key
    range_key       = var.gsi1_sort_key
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "GSI2"
    hash_key        = var.gsi2_partition_key
    range_key       = var.gsi2_sort_key
    projection_type = "ALL"
  }

  tags = {
    Name = var.table_name
  }
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}