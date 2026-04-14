variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  default = "blog-backup"
}

# when you change the bucket name here, make sure to update the bucket name in the lambda function code as well, which is passed as an environment variable from the github actions
variable "s3_bucket_name" {
  default = "goutham469-blog-backup"
}

# if you want to change the lambda function name, you can do it here and remember to update the function name in the .yml file as well
variable "lambda_function_name" {
  default = "blog-backup-lambda"
}