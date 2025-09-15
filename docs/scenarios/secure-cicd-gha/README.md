# Secure CI/CD with GitHub Actions (GHA) — Scenario

This scenario demonstrates deploying a StackSet-driven remediation solution that enforces guardrails across accounts/OU.

See the implementation in `Infra/solutions/scenario-s003-000-secure-cicd-gha/` for Terraform, Terragrunt, CloudFormation template, and a Lambda remediation stub.

Quickstart

1. Build the Lambda package and upload to a private S3 bucket.
2. Edit the Terragrunt inputs in `Infra/solutions/scenario-s003-000-secure-cicd-gha/terragrunt.hcl` to set `lambda_code_bucket` and `target_account_ids`.
3. Run `terragrunt apply` from the solution folder (use least-privilege deployment role and secure credentials).
4. Create StackSet instances using the AWS CLI or Console.

Security note: rotate credentials if they were exposed and never commit secrets to this repository.
