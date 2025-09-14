# Scenario 2: Centralized CloudTrail (overview)

This folder contains a complete runbook, implementation examples, scripts and a CI pipeline example to design and operate an organization-wide CloudTrail with full coverage, delivered to a central encrypted S3 bucket with monitoring and a guardrail Lambda.

Contents

- `runbook.md` — STAR summary, runbook and troubleshooting
- `implementation.md` — step-by-step implementation plan, permissions, prerequisites
- `terraform/` — example Terraform to provision Org CloudTrail, S3 and KMS (example, must run from Management Org account)
- `scripts/` — guardrail lambda example, deploy helper
- `ci/` — CI pipeline guide and example GitHub Actions workflow

Read `runbook.md` first. The Terraform examples are intentionally minimal and annotated. Do not run them in production without review.
