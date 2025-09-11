# Solution 02 — Terraform Plan + Approval (DevOps)

Purpose: Demonstrate safe IaC change management: plan-as-artifact, code review, and gated `terraform apply` using GitHub environments and OIDC.

Key features:
- `terraform plan` runs in PR and uploads plan JSON as artifact
- Apply requires manual approval (GitHub environment protection or workflow_dispatch with reviewer)
- Use least-privilege IAM role for `apply` (assumed via GitHub OIDC)
- Static checks: `terraform fmt`, `tflint`, `checkov`

Files included:
- `.github/workflows/terraform-plan.yml` (plan on PR)
- `.github/workflows/terraform-apply.yml` (apply manually via protected environment)
- `terraform/` — sample module to create VPC/EKS/ECR (scaffold)
- `scripts/approve_and_apply.sh` — helper that runs apply when triggered

Notes: By default, we recommend manual approval for production applies. For dev environments, use automation with policy-as-code approvals.
