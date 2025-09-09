CI/CD Pipeline Guide — GitHub Actions for S3 Public Access Prevention

Audience: engineers with limited CI/CD experience. This guide explains how the provided `ci-s3-security.yml` works, how to enable it, and what to expect.

Overview

The pipeline runs on pull requests and performs:
- Terraform init/validate/plan in `docs/scenarios/SCENARIO-1.1/terraform`
- Checkov scan for policy violations
- Grep the terraform plan for public ACL strings and fail the job if found

Why this pipeline exists

- Prevents accidental merges of IaC that would create public ACLs or disable BPA
- Provides an automated check that developers don't need to run locally

How to enable

1. Copy `docs/scenarios/SCENARIO-1.1/github-actions/ci-s3-security.yml` into `.github/workflows/ci-s3-security.yml` in your repo.
2. Adjust the checkov options and terraform path if needed.
3. Commit and open a PR to see the pipeline run.

What to expect in PR failure cases

- Checkov finds a policy violation: the Checkov step fails and shows the failing rule(s).
- The grep check finds `public-read` or similar in the plan: job fails with 'Public ACLs found in plan'.

Extending the pipeline

- Add `tfsec` or `cfn-lint` for CloudFormation support.
- Add a step to `terraform fmt` or `tflint` for style and linting.
- Add a notification step to post results back to PR (via GitHub Checks API) or Slack.

Pitfalls and debugging

- Plan JSON parsing may vary between Terraform versions; the `jq` path in the workflow may need adjustment.
- Checkov defaults may flag benign items; tune `skip-check` or `check` lists.

Useful commands (local testing)

```bash
# Run Checkov locally
pip install checkov
checkov -d docs/scenarios/SCENARIO-1.1/terraform

# Run terraform plan locally and inspect
cd docs/scenarios/SCENARIO-1.1/terraform
terraform init
terraform plan -out=tfplan
terraform show -json tfplan | jq '.'
```

Recommended pipeline use cases for other scenarios

- Use similar gating for IAM changes, ensuring least privilege before merging.
- Use a pipeline that runs SCA (software composition analysis) for dependencies.
- Use pipelines to run automated security tests (e.g., Checkov, tfsec) for all IaC repositories.
