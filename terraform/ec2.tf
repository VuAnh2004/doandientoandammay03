# ============================================
# ec2.tf
# ============================================

resource "aws_instance" "web_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t3.small"
  key_name      = "webdt3-key"
  subnet_id     = data.aws_subnet.subnet_1.id

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = { Name = "webdt3-server" }

  lifecycle {
    ignore_changes  = [associate_public_ip_address]
    prevent_destroy = true  # ← thêm để chắc chắn không bị xóa
  }
}

resource "aws_instance" "db_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t3.small"
  key_name      = "webdt3-key"
  subnet_id     = data.aws_subnet.subnet_1.id

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.db_sg.id]  # ← sửa từ web_sg thành db_sg

  tags = { Name = "webdt3-db-server" }

  lifecycle {
    ignore_changes  = [associate_public_ip_address]
    prevent_destroy = true 
  }
}
resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id
  domain   = "vpc"
  tags     = { Name = "webdt3-web-eip" }
}