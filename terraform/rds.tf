# ============================================
# rds.tf
# ============================================

resource "aws_db_subnet_group" "rds_subnet" {
  name = "webdt3-rds-subnet"
  subnet_ids = [
    data.aws_subnet.subnet_1.id,
    data.aws_subnet.subnet_2.id,
  ]
  tags = { Name = "webdt3-rds-subnet" }
}

resource "aws_db_instance" "sql_server" {
  identifier        = "webdt3-rds"
  engine            = "sqlserver-ex"
  engine_version    = "15.00"
  instance_class    = "db.t3.micro"  # ← đổi thành micro
  allocated_storage = 20
  username          = "admin"
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az            = false
  license_model       = "license-included"  # ← thêm dòng này, bắt buộc với SQL Server

  tags = { Name = "webdt3-rds" }
}