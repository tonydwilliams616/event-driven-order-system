resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  hash_key     = var.hash_key
  billing_mode = var.billing_mode

  attribute {
    name = var.hash_key
    type = "S"
  }

  stream_enabled   = var.enable_stream
  stream_view_type = var.enable_stream ? var.stream_view_type : null

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  tags = var.tags
}