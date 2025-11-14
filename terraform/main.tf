module "orders_table" {
  source        = "./modules/dynamodb"
  table_name    = "${var.project_name}-orders"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "orderId"
  enable_stream = true
}

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

module "api_gateway" {
  source     = "./modules/api-gateway"
  name       = "${var.project_name}-api"
  lambda_arn = module.create_order_lambda.lambda_arn
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