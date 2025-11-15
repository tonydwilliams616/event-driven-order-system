module "orders_table" {
  source        = "./modules/dynamodb"
  table_name    = "${var.project_name}-orders"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "orderId"
  enable_stream = true
}

# Create Order Lambda
module "create_order_lambda" {
  source         = "./modules/lambda"
  function_name  = "${var.project_name}-create-order"
  handler        = "app.lambda_handler"
  runtime        = "python3.12"
  source_path    = "../lambdas/create_order"
  environment_vars = {
    ORDERS_TABLE = module.orders_table.table_name
  }
}

# Payment Lambda
module "payment_service_lambda" {
  source         = "./modules/lambda"
  function_name  = "${local.app_prefix}-payment-service"
  handler        = "app.lambda_handler"
  runtime        = "python3.12"
  filename       = local.lambda_paths["payment_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn
}

# Inventory Lambda
module "inventory_service_lambda" {
  source         = "./modules/lambda"
  function_name  = "${local.app_prefix}-inventory-service"
  handler        = "app.lambda_handler"
  runtime        = "python3.12"
  filename       = local.lambda_paths["inventory_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn
}

# Notification Lambda
module "notification_service_lambda" {
  source         = "./modules/lambda"
  function_name  = "${local.app_prefix}-notification-service"
  handler        = "app.lambda_handler"
  runtime        = "python3.12"
  filename       = local.lambda_paths["notification_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn

  environment_vars = {
    SNS_TOPIC_ARN = module.notifications.sns_topic_arn
  }
}

# Analytics Lambda
module "analytics_service_lambda" {
  source         = "./modules/lambda"
  function_name  = "${local.app_prefix}-analytics-service"
  handler        = "app.lambda_handler"
  runtime        = "python3.12"
  filename       = local.lambda_paths["analytics_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn

  environment_vars = {
    ANALYTICS_BUCKET = module.analytics_bucket.bucket_id
  }
}

module "api_gateway" {
  source     = "./modules/api-gateway"
  name       = "${var.project_name}-api"
  lambda_arn = module.create_order_lambda.lambda_arn
  route_key  = "POST /orders"
}

module "event_bus" {
  source     = "./modules/eventbridge"
  bus_name   = "${var.project_name}-bus"
  source_dynamodb_stream_arn = module.orders_table.stream_arn
  target_lambdas = [
    module.payment_service_lambda.lambda_arn,
    module.inventory_service_lambda.lambda_arn,
    module.notification_service_lambda.lambda_arn,
    module.analytics_service_lambda.lambda_arn,
  ]
}

module "notifications" {
  source     = "./modules/sns_ses"
  topic_name = "${local.app_prefix}-notifications"
  email_identity = null # OR "your-email@example.com"
}

module "analytics_bucket" {
  source      = "./modules/s3"
  bucket_name = "${local.app_prefix}-analytics"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.app_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}