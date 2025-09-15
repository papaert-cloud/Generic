# DevOps Solution 02 — Terraform Plan + Approval (High-impact)

Situation
Infrastructure changes must be reviewed and approved to prevent accidental or malicious changes to production accounts.

Goal
Implement plan-as-artifact and a gated apply model where `terraform plan` runs automatically in PR and `terraform apply` only runs after approval using GitHub protected environments.

Design
- `terraform-plan.yml` runs on PR and uploads `plan.json` as artifact.
- `terraform-apply.yml` (manual run or environment-protected dispatch) will assume a narrowly scoped IAM role via GitHub OIDC that has `Apply` permissions.
- Static analysis: `tflint`, `terraform validate`, `checkov` run in PR to catch misconfigurations.

IAM & Roles
- Role `GitHubActionsTerraformApply` in each account with policies restricting actions to required resource types and conditions.
- OIDC trust policy limited to repo and branch (sub claim) to reduce blast radius.

Evidence & Auditing
- Collect `plan.json`, `apply.log`, and `state` snapshots into the artifact S3 bucket.
- Use AWS Config and CloudTrail for post-apply drift and audit trails.

Runbook (high-level)
1. Developer opens PR with infra change.
2. CI runs `plan` -> uploads `plan.json`.
3. Reviewer inspects plan artifact; if approved, triggers `apply` through protected environment which assumes the apply role.

Commands (WSL):
```bash
# create plan locally
cd github-actions/devops/solution-02-infra-approval/terraform
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > plan.json
```

Why this is DevOps
- Aims to enforce change control and operational safety. DevSecOps augments this with policy-as-code and automated security gates (see DevSecOps docs).
