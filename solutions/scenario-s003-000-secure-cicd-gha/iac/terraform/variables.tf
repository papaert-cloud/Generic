variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for control-plane resources"
}

variable "github_owner" {
  type        = string
  description = "GitHub organization/user name"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
}

variable "allowed_refs" {
  description = "Allowed refs (e.g., [\"refs/heads/main\", \"refs/tags/v*\"])"
  type        = list(string)
  default     = ["refs/heads/main"]
}

variable "allowed_environments" {
  description = "Allowed GitHub environments (e.g., [\"prod\", \"staging\"])"
  type        = list(string)
  default     = []
}

variable "github_oidc_thumbprints" {
  description = "Thumbprint list for token.actions.githubusercontent.com root cert"
  type        = list(string)
  default     = []
}

variable "role_name" {
  type        = string
  default     = "GA-Deployer"
  description = "Name of the IAM role assumed by GitHub Actions"
}

variable "permissions_boundary_arn" {
  type        = string
  default     = ""
  description = "Optional permissions boundary ARN to cap the role's permissions"
}

variable "tags" {
  type = map(string)
  default = {
    Project  = "superlab"
    Scenario = "S003-000"
    Owner    = "Peter"
  }
}
