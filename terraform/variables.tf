variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used for resource prefixes"
  default     = "event-driven-architecture"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
  default     = "dev"
}