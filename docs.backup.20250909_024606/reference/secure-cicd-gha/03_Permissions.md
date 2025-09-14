# Permissions, Roles & Policies

## Minimal AWS prerequisites
- Ability to create IAM resources: `iam:CreateOpenIDConnectProvider`, `iam:CreateRole`, `iam:PutRolePolicy`, `iam:CreatePolicy`.
- If you use Terraform S3 remote state: permissions to create/read S3 bucket & DynamoDB table.
- If deploying infra: grant only the services your modules manage (e.g., S3/CloudWatch/IAM/CloudTrail, etc.).

## Trust policy scoping
Use **conditions** to restrict **who** can assume the role:
- **audience**: `token.actions.githubusercontent.com:aud = "sts.amazonaws.com"`
- **subject**: `token.actions.githubusercontent.com:sub = "repo:OWNER/REPO:ref:refs/heads/main"`
  - Swap the tail for PRs, tags, or environments as needed.

## Session policy & permissions boundary (optional)
- A **permissions boundary** caps what the role can ever do.
- A **session policy** (inline on `assume-role`) can further narrow permissions per job.
