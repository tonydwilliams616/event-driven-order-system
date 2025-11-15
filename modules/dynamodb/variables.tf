variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "Partition key attribute name"
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Billing mode for the table (e.g. PAY_PER_REQUEST or PROVISIONED)"
}

variable "enable_stream" {
  type        = bool
  default     = false
  description = "Enable DynamoDB Streams"
}

variable "stream_view_type" {
  type        = string
  default     = "NEW_IMAGE"
  description = "Stream view type"
}

variable "ttl_enabled" {
  type        = bool
  default     = false
  description = "Enable TTL on the table"
}

variable "ttl_attribute_name" {
  type        = string
  default     = "ttl"
  description = "TTL attribute name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the table"
}