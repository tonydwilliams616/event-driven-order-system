output "api_endpoint" {
  description = "Invoke URL for the Orders API"
  value       = module.api_gateway.invoke_url
}

output "orders_table_name" {
  value = module.orders_table.table_name
}

output "event_bus_name" {
  value = module.event_bus.event_bus_name
}

output "notifications_topic" {
  value = module.notifications.sns_topic_arn
}

output "analytics_bucket" {
  value = module.analytics_bucket.bucket_id
}