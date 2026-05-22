resource "aws_instance" "web_server" {

  ami           = "ami-0fc5d935ebf8bc3bc"

  instance_type = "t3.small"

  key_name = "webdt3-key"

  subnet_id = aws_subnet.public_subnet.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  tags = {
    Name = "webdt3-server"
  }
}

resource "aws_instance" "db_server" {

  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t3.small"

  subnet_id = aws_subnet.public_subnet.id

  associate_public_ip_address = true

  key_name = "webdt3-key"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  tags = {
    Name = "webdt3-db-server"
  }
}