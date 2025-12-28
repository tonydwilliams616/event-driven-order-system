variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable versioning on the bucket"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "SSE algorithm (AES256 or aws:kms)"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID for SSE if using aws:kms"
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id              = string
    enabled         = bool
    prefix          = string
    transition_days = number
    storage_class   = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the bucket"
}