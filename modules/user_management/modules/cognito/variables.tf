#############################################
################User Management##############
#############################################
variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
  default     = "user-pool"
}

variable "user_pool_client_name" {
  description = "The name of the Cognito User Pool Client"
  type        = string
  default     = "user-pool-client"
}

variable "password_minimum_length" {
  description = "Minimum length of the password"
  type        = number
  default     = 8
}

variable "require_lowercase" {
  description = "Require lowercase characters in the password"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Require numbers in the password"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Require symbols in the password"
  type        = bool
  default     = true
}

variable "require_uppercase" {
  description = "Require uppercase characters in the password"
  type        = bool
  default     = true
}

variable "auto_verified_attributes" {
  description = "The attributes to be auto-verified"
  type        = list(string)
  default     = ["email"]
}

variable "explicit_auth_flows" {
  description = "The authentication flows that are supported"
  type        = list(string)
  default     = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

variable "allowed_oauth_flows" {
  description = "Allowed OAuth flows"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_flows_user_pool_client" {
  description = "Whether the client is allowed to follow OAuth flows"
  type        = bool
  default     = true
}

variable "allowed_oauth_scopes" {
  description = "Allowed OAuth scopes"
  type        = list(string)
  default     = ["phone", "email", "openid", "profile"]
}

variable "callback_urls" {
  description = "A list of allowed callback URLs for the identity providers"
  type        = list(string)
  default     = ["https://example.com/callback"]
}

variable "post_confirmation_arn" {
  description = "The ARN of the Lambda function to execute after a user is confirmed"
  type        = string
}
variable "user_role_arn"{
  description = "The ARN of the policy to attach to the users group"
  type        = string
}
variable "admin_role_arn"{
  description = "The ARN of the policy to attach to the admins group"
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

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}
