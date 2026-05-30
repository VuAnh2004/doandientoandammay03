# ============================================
# security.tf
# ============================================

# 1. Security Group cho Web Server (Public)
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and Web traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web App Port"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "webdt3-web-sg" }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [description, ingress, egress]
  }
}

# 2. Security Group cho DMS
resource "aws_security_group" "dms_sg" {
  name        = "dms-sg"
  description = "Security group for DMS migration"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "webdt3-dms-sg" }

  lifecycle {
    create_before_destroy = true
  }
}

# 3. Security Group cho Database (Private)
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for Database"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "webdt3-db-sg" }

  lifecycle {
    create_before_destroy = true
  }
}

# 4. Rules cho Database SG
resource "aws_security_group_rule" "db_allow_web" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.web_sg.id
  description              = "Allow Web Server to access DB"
}

resource "aws_security_group_rule" "db_allow_dms" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.dms_sg.id
  description              = "Allow DMS to access DB"
}