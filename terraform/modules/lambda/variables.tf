variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "api_url" {
  description = "API endpoint for retrieving blog posts"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for backups"
  type        = string
}