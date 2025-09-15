variable "region" {
  description = "Primary AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "config_aggregator_role_arn" {
  description = "IAM role ARN used by Config aggregator in management account"
  type        = string
}

variable "excluded_accounts" {
  description = "List of account IDs to exclude from organization rules"
  type        = list(string)
  default     = []
}

variable "alert_email" {
  description = "Email address to subscribe to the SNS topic for alerts"
  type        = string
}
