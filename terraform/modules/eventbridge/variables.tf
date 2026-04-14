variable "lambda_arn" {
  description = "ARN of the Lambda function to be triggered"
  type        = string
}

variable "schedule_rate" {
  description = "Schedule expression for EventBridge"
  type        = string
}