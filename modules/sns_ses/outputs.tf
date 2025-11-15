output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.notifications.arn
}

output "ses_email_identity_arn" {
  description = "ARN of the SES email identity (if created)"
  value       = aws_ses_email_identity.this[0].arn
}