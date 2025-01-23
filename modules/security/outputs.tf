output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.api_gateway_waf.arn
}

output "blocked_ips_set_arn" {
  description = "ARN of the blocked IPs set"
  value       = aws_wafv2_ip_set.blocked_ips.arn
}