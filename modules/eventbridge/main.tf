resource "aws_cloudwatch_event_bus" "this" {
  name = var.bus_name
}

resource "aws_cloudwatch_event_rule" "order_created" {
  name          = "${var.bus_name}-order-created"
  event_bus_name = aws_cloudwatch_event_bus.this.name

  event_pattern = jsonencode({
    source      = [var.order_created_source]
    "detail-type" = [var.order_created_detail_type]
  })
}

resource "aws_cloudwatch_event_target" "lambda_targets" {
  for_each       = var.target_lambdas
  rule           = aws_cloudwatch_event_rule.order_created.name
  event_bus_name = aws_cloudwatch_event_bus.this.name
  arn            = each.value
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each = var.target_lambdas

  statement_id  = "AllowExecutionFromEventBridge-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.order_created.arn
}