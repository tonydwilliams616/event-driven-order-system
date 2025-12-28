variable "bus_name" {
  type        = string
  description = "Name of the custom EventBridge event bus"
}

variable "order_created_source" {
  type        = string
  default     = "custom.orders"
  description = "Event source field for OrderCreated events"
}

variable "order_created_detail_type" {
  type        = string
  default     = "OrderCreated"
  description = "Detail-type for OrderCreated events"
}

variable "target_lambdas" {
  type        = map(string)
  description = "Map of target Lambda logical names to ARNs"
}