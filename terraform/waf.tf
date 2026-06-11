# ============================================
# waf.tf
# ============================================

resource "aws_wafv2_web_acl" "web_acl" {
  name  = "webdt3-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # Rule 1: Chặn SQL Injection
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  # Rule 2: Chặn Common Threats (XSS, Bad Input)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # Rule 3: Giới hạn request từ 1 IP (Rate Limiting)
  rule {
    name     = "RateLimitRule"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000  # 1000 request/5 phút
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webdt3WafMetric"
    sampled_requests_enabled   = true
  }

  tags = { Name = "webdt3-waf" }
}

# Gắn WAF vào ALB
resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = aws_lb.web_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}