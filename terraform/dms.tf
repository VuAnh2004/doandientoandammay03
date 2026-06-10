# --- dms.tf ---

resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_id          = "webdt3-dms-group"
  replication_subnet_group_description = "DMS subnet group cho webdt3"
  subnet_ids                           = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]
}

resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_id      = "webdt3-dms-instance"
  replication_instance_class   = "dms.t3.medium"
  allocated_storage            = 25
  publicly_accessible          = true
  vpc_security_group_ids       = [data.aws_security_group.db_sg.id]
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id
}

resource "aws_dms_endpoint" "source" {
  endpoint_id   = "sqlserver-source-v2"
  endpoint_type = "source"
  engine_name   = "sqlserver"
  server_name   = "10.0.1.174"
  port          = 1433
  database_name = "QLTH"
  username      = "sa"
  password      = "Anh@12345"
  ssl_mode      = "none"
}

resource "aws_dms_endpoint" "target" {
  endpoint_id   = "rds-target-v3"
  endpoint_type = "target"
  engine_name   = "sqlserver"
  server_name   = aws_db_instance.sql_server.address
  port          = 1433
  database_name = "QLTH"
  username      = "admin"
  password      = "Anh12345"
  ssl_mode      = "none"
}

resource "aws_dms_replication_task" "cdc_task" {
  replication_task_id      = "webdt3-cdc-task-v2"
  replication_instance_arn = aws_dms_replication_instance.dms_instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target.endpoint_arn
  migration_type           = "full-load-and-cdc"
  start_replication_task   = false

  table_mappings = jsonencode({
    rules = [{
      "rule-type"    = "selection"
      "rule-id"      = "1"
      "rule-name"    = "include-all"
      "object-locator" = {
        "schema-name" = "dbo"
        "table-name"  = "%"
      }
      "rule-action"  = "include"
    }]
  })

  replication_task_settings = jsonencode({
    Logging = { EnableLogging = true }
    FullLoadSettings = { TargetTablePrepMode = "DROP_AND_CREATE" }
    ChangeProcessingTuning = { BatchApplyEnabled = false }
    ErrorBehavior = {
      FailOnNoTablesCaptured = true
      TableErrorPolicy       = "SUSPEND_TABLE"
    }
  })
}