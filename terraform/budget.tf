# ============================================
# budget.tf
# ============================================

# Cảnh báo khi chi phí vượt $10/tháng
resource "aws_budgets_budget" "monthly_cost" {
  name         = "webdt3-monthly-budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  # Cảnh báo 1: Khi đạt 80% ngưỡng ($8)
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["vvanh0304@gmail.com"]
  }

  # Cảnh báo 2: Khi đạt 100% ngưỡng ($10)
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["vvanh0304@gmail.com"]
  }

  # Cảnh báo 3: Dự báo vượt ngưỡng
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["vvanh0304@gmail.com"]
  }
}

# Cảnh báo riêng cho EC2
resource "aws_budgets_budget" "ec2_cost" {
  name         = "webdt3-ec2-budget"
  budget_type  = "COST"
  limit_amount = "5"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Elastic Compute Cloud - Compute"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["vvanh0304@gmail.com"]
  }
}

# Cảnh báo riêng cho RDS
resource "aws_budgets_budget" "rds_cost" {
  name         = "webdt3-rds-budget"
  budget_type  = "COST"
  limit_amount = "3"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Relational Database Service"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["vvanh0304@gmail.com"]
  }
}