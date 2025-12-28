variable "name" {
  type = string
}

variable "routes" {
  type = map(object({
    lambda_arn = string
  }))
}