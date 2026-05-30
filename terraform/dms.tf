# ============================================
# dms.tf
# ============================================

# --- 1. THAM CHIẾU HẠ TẦNG ---
data "aws_security_group" "db_sg" {
  id = "sg-0221cf9c48dea7d6b"
}

# --- 2. CẤU HÌNH DMS REPLICATION ---
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_id          = "webdt3-dms-group"
  replication_subnet_group_description = "DMS subnet group cho webdt3"
  subnet_ids = [
    data.aws_subnet.subnet_1.id,
    data.aws_subnet.subnet_2.id,
  ]

  depends_on = [aws_iam_role_policy_attachment.dms_vpc_role_policy]
}

resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_id     = "webdt3-dms-instance"
  replication_instance_class  = "dms.t3.medium"  # ← sửa từ micro thành medium
  allocated_storage           = 20
  vpc_security_group_ids      = [data.aws_security_group.db_sg.id]
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnet_group.id
  publicly_accessible         = true

  depends_on = [aws_iam_role_policy_attachment.dms_vpc_role_policy]
}

# --- 3. ENDPOINTS ---
resource "aws_dms_endpoint" "source" {
  endpoint_id   = "sqlserver-source"
  endpoint_type = "source"
  engine_name   = "sqlserver"
  username      = "sa"
  password      = var.db_password
  server_name   = "10.0.1.174"
  port          = 1433
  database_name = "QLTH"
  # xóa extra_connection_attributes vì SQL Server không cần
}

resource "aws_dms_endpoint" "target" {
  endpoint_id   = "sqlserver-target"
  endpoint_type = "target"
  engine_name   = "sqlserver"
  username      = "sa"
  password      = var.db_password
  server_name   = "10.0.1.22"
  port          = 1433
  database_name = "QLTH"
}

# --- 4. REPLICATION TASK ---
resource "aws_dms_replication_task" "migration_task" {
  replication_task_id      = "webdt3-migration-task"
  migration_type           = "full-load"
  replication_instance_arn = aws_dms_replication_instance.dms_instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target.endpoint_arn
  start_replication_task   = false

  table_mappings = jsonencode({
    rules = [{
      "rule-type" = "selection"
      "rule-id"   = "1"
      "rule-name" = "1"
      "object-locator" = {
        "schema-name" = "dbo"
        "table-name"  = "%"
      }
      "rule-action" = "include"
    }]
  })
}