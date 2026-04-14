provider "aws" {
  region = var.aws_region # Change this to your AWS region
}

# Include the S3 module
module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

# Include the Lambda module
module "lambda_function" {
  source         = "./modules/lambda"
  function_name  = var.lambda_function_name
  api_url        = "https://example.com/api/blog-posts"
  s3_bucket_name = module.s3_bucket.bucket_name
}


# Include the EventBridge module
module "eventbridge_rule" {
  source        = "./modules/eventbridge"
  lambda_arn    = module.lambda_function.lambda_arn
  schedule_rate = "rate(2 minutes)"
}