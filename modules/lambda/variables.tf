variable "function_name" {}
variable "handler" {}
variable "runtime" {}
variable "environment_vars" {
  type    = map(string)
  default = {}
}
variable "lambda_role_arn" {}