# resource "aws_wafregional_web_acl" "api_gw_waf" {
#   name        = var.name
#   metric_name = var.metric_name

#   default_action {
#     type = "ALLOW"
#   }

#   rule {
#     action {
#       type = "BLOCK"
#     }
#     priority = 1
#     rule_id  = aws_wafregional_rule.sql_injection_rule.id
#   }

#   rule {
#     action {
#       type = "BLOCK"
#     }
#     priority = 2
#     rule_id  = aws_wafregional_rule.xss_rule.id
#   }

#   rule {
#     action {
#       type = "BLOCK"
#     }
#     priority = 4
#     rule_id  = aws_wafregional_rule.geo_block_rule.id
#   }

# depends_on = [
#   aws_wafregional_rule.sql_injection_rule,
#   aws_wafregional_rule.xss_rule,
#   aws_wafregional_rule.geo_block_rule,
#   aws_wafregional_rate_based_rule.rate_limit_rule,
#   aws_wafregional_sql_injection_match_set.sql_injection_set,
#   aws_wafregional_xss_match_set.xss_set,
#   aws_wafregional_geo_match_set.geo_set,
#   aws_wafregional_ipset.ip_set,
# ]
# }

# # SQL Injection Rule
# resource "aws_wafregional_rule" "sql_injection_rule" {
#   name        = "SQLInjectionRule"
#   metric_name = "SQLInjectionRule"

#   predicate {
#     data_id = aws_wafregional_sql_injection_match_set.sql_injection_set.id
#     negated = false
#     type    = "SqlInjectionMatch"
#   }
# }

# resource "aws_wafregional_sql_injection_match_set" "sql_injection_set" {
#   name = "SQLInjectionSet"

#   sql_injection_match_tuple {
#     field_to_match {
#       type = "QUERY_STRING"
#     }
#     text_transformation = "URL_DECODE"
#   }
# }

# # XSS Rule
# resource "aws_wafregional_rule" "xss_rule" {
#   name        = "XSSRule"
#   metric_name = "XSSRule"

#   predicate {
#     data_id = aws_wafregional_xss_match_set.xss_set.id
#     negated = false
#     type    = "XssMatch"
#   }
# }

# resource "aws_wafregional_xss_match_set" "xss_set" {
#   name = "XSSSet"

#   xss_match_tuple {
#     field_to_match {
#       type = "QUERY_STRING"
#     }
#     text_transformation = "URL_DECODE"
#   }
# }

# # Rate Limit Rule
# resource "aws_wafregional_rate_based_rule" "rate_limit_rule" {
#   name        = "RateLimitRule"
#   metric_name = "RateLimitRule"
#   rate_key    = "IP"
#   rate_limit  = 2000

#   predicate {
#     data_id = aws_wafregional_ipset.ip_set.id
#     negated = false
#     type    = "IPMatch"
#   }
# }

# resource "aws_wafregional_ipset" "ip_set" {
#   name = "IPSet"
# }

# # Geo Block Rule
# resource "aws_wafregional_rule" "geo_block_rule" {
#   name        = "GeoBlockRule"
#   metric_name = "GeoBlockRule"

#   predicate {
#     data_id = aws_wafregional_geo_match_set.geo_set.id
#     negated = false
#     type    = "GeoMatch"
#   }
# }

# resource "aws_wafregional_geo_match_set" "geo_set" {
#   name = "GeoSet"

#   geo_match_constraint {
#     type  = "Country"
#     value = "CN" # Block China as an example
#   }
# }

# resource "aws_wafregional_web_acl_association" "api_gw_waf_association" {
#   resource_arn = var.aws_api_gateway_deployment_arn
#   web_acl_id   = aws_wafregional_web_acl.api_gw_waf.id
#   depends_on = [aws_wafregional_web_acl.api_gw_waf]
# }