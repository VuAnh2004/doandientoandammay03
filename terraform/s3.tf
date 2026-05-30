# Tạo S3 Bucket
resource "aws_s3_bucket" "my_project_bucket" {
  bucket = "webdt3-storage-bucket-unique-id" # Thay thế bằng tên bucket duy nhất của bạn

  tags = {
    Name        = "WebDT3 Storage"
    Environment = "Production"
  }
}

# Cấu hình Block Public Access (Quan trọng để bảo mật)
resource "aws_s3_bucket_public_access_block" "my_project_bucket_access" {
  bucket = aws_s3_bucket.my_project_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}