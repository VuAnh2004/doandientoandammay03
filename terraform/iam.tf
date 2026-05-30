# Định nghĩa Role cho phép EC2 đảm nhận
resource "aws_iam_role" "ec2_role" {
  name = "webdt3-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Tạo profile để gắn Role vào EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "webdt3-instance-profile"
  role = aws_iam_role.ec2_role.name
}