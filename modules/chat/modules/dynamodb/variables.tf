variable "table_name" {
  description = "The name of the DynamoDB table"
}

variable "partition_key" {
  description = "The partition key of the DynamoDB table"
}

variable "sort_key" {
  description = "The sort key of the DynamoDB table"
}

variable "gsi1_partition_key" {
  description = "The partition key of the GSI1"
}

variable "gsi1_sort_key" {
  description = "The sort key of the GSI1"
}

variable "gsi2_partition_key" {
  description = "The partition key of the GSI2"
}

variable "gsi2_sort_key" {
  description = "The sort key of the GSI2"
}