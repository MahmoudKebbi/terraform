output "service_url" {
  value = aws_lb.this.dns_name
}

output "nlb_arn" {
  value = aws_lb.this.arn
}