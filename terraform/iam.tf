# ============================================
# iam.tf
# ============================================

# --- 1. EC2 IAM ROLE ---
resource "aws_iam_role" "ec2_role" {
  name = "webdt3-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  lifecycle {
    prevent_destroy = true
  }
}

# Gắn policy S3 cho EC2
resource "aws_iam_role_policy_attachment" "ec2_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Gắn policy CloudWatch cho EC2
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile để gắn Role vào EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "webdt3-instance-profile"
  role = aws_iam_role.ec2_role.name

  lifecycle {
    prevent_destroy = true
  }
}

# --- 2. DMS IAM ROLE ---
resource "aws_iam_role" "dms_vpc_role" {
  name = "dms-vpc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "dms.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dms_vpc_role_policy" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}