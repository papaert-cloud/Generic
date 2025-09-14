# SCENARIO 1.1 — Enforce no public S3 access across all AWS accounts

Quick start

1. This package is local-only and should be reviewed before applying.
2. Run from the AWS Organizations management account; set AWS_PROFILE to the management account profile.

Example:

```bash
export AWS_PROFILE=org-management
cd docs/scenarios/SCENARIO-1.1/terraform
./deploy.sh plan
```

The `terraform/` folder contains resources for an organization-level SCP, AWS Config organization rules, EventBridge rule, and SNS topic.
