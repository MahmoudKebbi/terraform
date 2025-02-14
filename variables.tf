variable "region" {
  description = "The region in which the resources are created"
  type        = string
}
variable "google_client_id" {
  description = "Google Client ID"
  type        = string
}

variable "google_client_secret" {
  description = "Google Client Secret"
  type        = string
}

variable "callback_urls" {
  description = "A list of allowed callback URLs for the identity providers"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}