resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime

  filename         = "${path.module}/package.zip"
  source_code_hash = filebase64sha256("${path.module}/package.zip")

  role = var.lambda_role_arn

  environment {
    variables = var.environment_vars
  }
}