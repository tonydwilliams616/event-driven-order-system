module "orders_table" {
  source        = "./modules/dynamodb"
  table_name    = "${var.project_name}-orders"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "orderId"
  enable_stream = true
}

module "dynamodb_to_eventbridge" {
  source              = "./modules/pipes"
  name                = "${local.app_prefix}-orders-pipe"
  dynamodb_stream_arn = module.orders_table.stream_arn
  event_bus_arn       = module.event_bus.event_bus_arn
}

# Create Order Lambda
module "create_order_lambda" {
  source          = "./modules/lambda"
  function_name   = "${var.project_name}-create-order"
  handler         = "app.lambda_handler"
  runtime         = "python3.12"
  filename        = local.lambda_paths["create_order"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn
  environment_vars = {
    ORDERS_TABLE = module.orders_table.table_name
  }
}

# Payment Lambda
module "payment_service_lambda" {
  source          = "./modules/lambda"
  function_name   = "${local.app_prefix}-payment-service"
  handler         = "app.lambda_handler"
  runtime         = "python3.12"
  lambda_role_arn = aws_iam_role.lambda_exec.arn
  filename        = local.lambda_paths["payment_service"]
}

# Inventory Lambda
module "inventory_service_lambda" {
  source          = "./modules/lambda"
  function_name   = "${local.app_prefix}-inventory-service"
  handler         = "app.lambda_handler"
  runtime         = "python3.12"
  filename        = local.lambda_paths["inventory_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn
}

# Notification Lambda
module "notification_service_lambda" {
  source          = "./modules/lambda"
  function_name   = "${local.app_prefix}-notification-service"
  handler         = "app.lambda_handler"
  runtime         = "python3.12"
  filename        = local.lambda_paths["notification_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn

  environment_vars = {
    SNS_TOPIC_ARN = module.notifications.sns_topic_arn
  }
}

# Analytics Lambda
module "analytics_service_lambda" {
  source          = "./modules/lambda"
  function_name   = "${local.app_prefix}-analytics-service"
  handler         = "app.lambda_handler"
  runtime         = "python3.12"
  filename        = local.lambda_paths["analytics_service"]
  lambda_role_arn = aws_iam_role.lambda_exec.arn

  environment_vars = {
    ANALYTICS_BUCKET = module.analytics_bucket.bucket_id
  }
}

# Health Check
module "healthcheck_lambda" {
  source          = "./modules/lambda"
  function_name   = "${local.app_prefix}-healthcheck"
  handler         = "app.lambda_handler"
  runtime         = "python3.12"
  filename        = "../lambdas/healthcheck/package.zip"
  lambda_role_arn = aws_iam_role.lambda_exec.arn
}

module "api_gateway" {
  source = "./modules/api-gateway"
  name   = "${local.app_prefix}-api"

  routes = {
    "POST /orders" = {
      lambda_arn = module.create_order_lambda.lambda_arn
    }
    "GET /health" = {
      lambda_arn = module.healthcheck_lambda.lambda_arn
    }
  }
}

module "event_bus" {
  source   = "./modules/eventbridge"
  bus_name = "${var.project_name}-bus"
  target_lambdas = {
    payment       = module.payment_service_lambda.lambda_arn
    inventory     = module.inventory_service_lambda.lambda_arn
    notifications = module.notification_service_lambda.lambda_arn
    analytics     = module.analytics_service_lambda.lambda_arn
  }
}

module "notifications" {
  source         = "./modules/sns_ses"
  topic_name     = "${local.app_prefix}-notifications"
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
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}