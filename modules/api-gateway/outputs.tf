output "api_id" {
  description = "ID of the HTTP API"
  value       = aws_apigatewayv2_api.this.id
}

output "invoke_url" {
  description = "Base invoke URL of the HTTP API"
  value       = aws_apigatewayv2_api.this.api_endpoint
}