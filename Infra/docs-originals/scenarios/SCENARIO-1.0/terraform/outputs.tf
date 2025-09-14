output "s3_public_alerts_topic_arn" {
  description = "SNS topic ARN for S3 public alerts"
  value       = aws_sns_topic.s3_public_alerts.arn
}

output "org_scp_id" {
  description = "ID of the created Organization SCP"
  value       = aws_organizations_policy.deny_public_s3_acls.id
}
