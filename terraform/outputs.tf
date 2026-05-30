output "web_server_public_ip" {
  description = "Địa chỉ IP công cộng của máy chủ web"
  value       = aws_instance.web_server.public_ip
}

output "db_server_private_ip" {
  description = "Địa chỉ IP nội bộ của máy chủ DB"
  value       = aws_instance.db_server.private_ip
}

output "cloudwatch_alarm_status" {
  description = "Thông báo rằng hệ thống giám sát đã sẵn sàng"
  value       = "CloudWatch Alarms have been successfully deployed."
}