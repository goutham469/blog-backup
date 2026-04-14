output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "lambda_arn" {
  value = module.lambda_function.lambda_arn
}