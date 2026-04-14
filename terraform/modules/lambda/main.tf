resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-s3-policy"
  description = "Policy for Lambda access to S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# to enable cloudwatch logs for the lambda function, we need to attach the AWSLambdaBasicExecutionRole policy to the lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# begin : Archive the lambda function code
terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.6"
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../lambda/build"
  output_path = "${path.module}/lambda.zip"
}

# end of lambda funtion code zipping tags

resource "aws_lambda_function" "backup_lambda" {
  function_name = var.function_name
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler"

  environment {
    variables = {
      API_URL    = var.api_url
      S3_BUCKET  = var.s3_bucket_name
    }
  }

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Name = "Blog Backup Lambda"
  }
}
