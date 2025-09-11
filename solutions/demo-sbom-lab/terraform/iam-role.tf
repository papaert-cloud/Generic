# Example IAM role (Terraform) showing a minimal trust policy for GitHub Actions OIDC
# Replace <AWS_ACCOUNT_ID> and <ROLE_NAME> before use. This is a template; adapt to your environment.

variable "aws_account_id" {
  type = string
}

variable "role_name" {
  type    = string
  default = "demo-github-actions-oidc-role"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "github_oidc_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:<owner>/<repo>:ref:refs/heads/*"
          },
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

output "role_arn" {
  value = aws_iam_role.github_oidc_role.arn
}
