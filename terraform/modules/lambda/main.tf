resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime

  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  role = var.lambda_role_arn

  timeout      = var.timeout
  memory_size  = var.memory_size
  description  = var.description
  architectures = var.architectures

  publish = var.publish

  environment {
    variables = var.environment_vars
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  layers = var.layers

  tags = var.tags
}