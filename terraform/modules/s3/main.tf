resource "aws_s3_bucket" "backup_bucket" {
  bucket        = var.bucket_name
  acl           = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Blog Backup Bucket"
  }
}