resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "blog-backup-schedule"
  schedule_expression = var.schedule_rate
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  target_id = "lambda"
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "eventbridge_permission" {
  statement_id  = "AllowEventBridgeToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}