#############################################
################User Management##############
#############################################
variable "users_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "users"
}

variable "billing_mode" {
  description = "The billing mode for the table"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The primary key attribute name"
  type        = string
  default     = "user_id"
}

variable "hash_key_type" {
  description = "The type of the primary key attribute"
  type        = string
  default     = "S"
}

variable "additional_attributes" {
  description = "Additional attributes for the table"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "server_side_encryption_enabled" {
  description = "Whether server-side encryption is enabled"
  type        = bool
  default     = true
}