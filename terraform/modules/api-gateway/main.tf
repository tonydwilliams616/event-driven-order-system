resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "integrations" {
  for_each               = var.routes
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = each.value.lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "routes" {
  for_each    = var.routes
  api_id      = aws_apigatewayv2_api.this.id
  route_key   = each.key
  target      = "integrations/${aws_apigatewayv2_integration.integrations[each.key].id}"
}

resource "aws_lambda_permission" "api_permissions" {
  for_each = var.routes

  statement_id = "AllowInvoke_${replace(replace(each.key, " ", "_"), "/", "_")}"

  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}