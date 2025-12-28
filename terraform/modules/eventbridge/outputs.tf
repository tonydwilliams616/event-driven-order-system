output "event_bus_arn" {
  description = "ARN of the custom EventBridge event bus"
  value       = aws_cloudwatch_event_bus.this.arn
}

output "event_bus_name" {
  description = "Name of the custom EventBridge event bus"
  value       = aws_cloudwatch_event_bus.this.name
}

output "order_created_rule_arn" {
  description = "ARN of the EventBridge rule for OrderCreated"
  value       = aws_cloudwatch_event_rule.order_created.arn
}