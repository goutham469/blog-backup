variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  default = "blog-backup"
}

variable "s3_bucket_name" {
  default = "goutham469-blog-backup"
}

variable "lambda_function_name" {
  default = "blog-backup-lambda"
}