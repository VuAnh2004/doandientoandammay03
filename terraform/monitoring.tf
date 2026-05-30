resource "aws_sns_topic" "alert_topic" {
  name = "webdt3-alert-topic"
}
  
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = "vvanh0304@gmail.com" # Đã cập nhật email mới
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_high" {
  alarm_name          = "WEB-CPU-HIGH"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "CPU Web Server > 70%"
  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
  alarm_actions = [aws_sns_topic.alert_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "db_cpu_high" {
  alarm_name          = "DB-CPU-HIGH"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "CPU Database Server > 70%"
  dimensions = {
    InstanceId = aws_instance.db_server.id
  }
  alarm_actions = [aws_sns_topic.alert_topic.arn]
}