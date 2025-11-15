resource "aws_sns_topic" "notifications" {
  name = var.topic_name

  tags = var.tags
}

resource "aws_ses_email_identity" "this" {
  count = var.email_identity != null ? 1 : 0

  email = var.email_identity
}