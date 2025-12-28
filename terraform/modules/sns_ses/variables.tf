variable "topic_name" {
  type        = string
  description = "Name of the SNS topic"
}

variable "email_identity" {
  type        = string
  default     = null
  description = "SES email identity to verify (optional)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}