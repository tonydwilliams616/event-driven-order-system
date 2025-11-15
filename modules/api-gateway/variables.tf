variable "name" {
  type        = string
  description = "Name of the API Gateway HTTP API"
}

variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda function to integrate with"
}

variable "route_key" {
  type        = string
  description = "Route key, e.g. 'POST /orders'"
}