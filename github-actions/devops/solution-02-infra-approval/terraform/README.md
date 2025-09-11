# Terraform scaffold — Infra Approval (plan + gated apply)

Purpose
- Scaffold to create OIDC-trusted IAM roles for GitHub Actions and required resources (ECR repo, S3 artifact bucket, KMS key).

How to use
1. Populate `terraform.tfvars` with your account-specific values (account_id, oidc_provider_arn, artifact_bucket_name, kms_key_alias).
2. Run locally for validation: (WSL)

```bash
cd github-actions/devops/solution-02-infra-approval/terraform
terraform init
terraform plan -var-file=terraform.tfvars
```

Notes
- This scaffold uses variables for OIDC provider and repository restrictions; do NOT hardcode secrets.
- The roles created are minimal and intended to be reviewed and tightened to your organization's policy.
