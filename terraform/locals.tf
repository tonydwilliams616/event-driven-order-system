locals {
  app_prefix = "${var.project_name}-${var.environment}"

  lambda_paths = {
    create_order         = "../lambdas/create_order/package.zip"
    payment_service      = "../lambdas/payment_service/package.zip"
    inventory_service    = "../lambdas/inventory_service/package.zip"
    notification_service = "../lambdas/notification_service/package.zip"
    analytics_service    = "../lambdas/analytics_service/package.zip"
    healthcheck          = "../lambdas/healthcheck/package.zip"
  }
}