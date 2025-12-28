variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "handler" {
  type        = string
  description = "Lambda handler (e.g. app.lambda_handler)"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime (e.g. python3.12)"
}

variable "filename" {
  type        = string
  description = "Path to the Lambda deployment package zip file"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN for the Lambda function"
}

variable "environment_vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the Lambda function"
}

variable "timeout" {
  type        = number
  default     = 10
  description = "Lambda timeout in seconds"
}

variable "memory_size" {
  type        = number
  default     = 128
  description = "Lambda memory size in MB"
}

variable "description" {
  type        = string
  default     = ""
  description = "Description of the Lambda function"
}

variable "architectures" {
  type        = list(string)
  default     = ["x86_64"]
  description = "Architectures (e.g. [\"arm64\"] or [\"x86_64\"])"
}

variable "publish" {
  type        = bool
  default     = false
  description = "Whether to publish a new version on update"
}

variable "vpc_subnet_ids" {
  type        = list(string)
  default     = null
  description = "Subnet IDs for VPC attachment (optional)"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = null
  description = "Security group IDs for VPC attachment (optional)"
}

variable "layers" {
  type        = list(string)
  default     = []
  description = "List of Lambda layer ARNs"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the function"
}