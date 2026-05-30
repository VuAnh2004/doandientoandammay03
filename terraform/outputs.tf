# ============================================
# outputs.tf
# ============================================

output "web_server_public_ip" {
  description = "IP public của Web Server"
  value       = aws_instance.web_server.public_ip
}

output "db_server_private_ip" {
  description = "IP private của DB Server"
  value       = aws_instance.db_server.private_ip
}

output "cloudwatch_alarm_status" {
  description = "Trạng thái CloudWatch Alarms"
  value       = "CloudWatch Alarms have been successfully deployed."
}

output "web_app_url" {
  description = "URL truy cập ứng dụng web"
  value       = "http://${aws_instance.web_server.public_ip}:9000"
}

output "vpn_gateway_id" {
  description = "ID của VPN Gateway"
  value       = aws_vpn_gateway.vpn_gw.id
}

output "dms_instance_arn" {
  description = "ARN của DMS Replication Instance"
  value       = aws_dms_replication_instance.dms_instance.replication_instance_arn
}