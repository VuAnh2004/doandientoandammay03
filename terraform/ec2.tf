# ec2.tf
resource "aws_instance" "web_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t3.small"
  key_name      = "webdt3-key"
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  
  # Gắn IAM Profile đã tạo ở trên
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "webdt3-server"
  }
}

resource "aws_instance" "db_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t3.small"
  key_name      = "webdt3-key"
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  # Gắn IAM Profile vào
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Khuyên dùng: dùng một db_sg riêng biệt để bảo mật hơn
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "webdt3-db-server"
  }
}