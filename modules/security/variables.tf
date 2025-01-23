variable "rate_limit" {
  description = "Maximum number of requests allowed from a single IP in 5 minutes"
  type        = number
  default     = 2000
}

variable "blocked_ip_list" {
  description = "List of IP addresses to block"
  type        = list(string)
  default     = []
}

variable "api_gateway_arn" {
  description = "ARN of the API Gateway to associate with WAF"
  type        = string
}