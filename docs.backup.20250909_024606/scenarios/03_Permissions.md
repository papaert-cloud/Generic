```markdown
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

## Example minimal role (trust policy)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:OWNER/REPO:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

## Minimal permissions policy for CI (example)

Paraphrase the principle: give the role only the API actions required to perform tasks (plan/apply, S3 state, ECR push). Example policy snippet:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": ["s3:GetObject","s3:PutObject","s3:ListBucket"], "Resource": "arn:aws:s3:::org-terraform-state-*" },
    { "Effect": "Allow", "Action": ["sts:AssumeRole"], "Resource": "arn:aws:iam::123456789012:role/DeployRole" }
  ]
}
```

## Hardening tips
- Use permissions boundaries for cross-account roles.
- Scope the `sub` condition to the exact repo/ref or environment tag.
- Add a short-lived session policy via the OIDC flow per job when needed.

```
