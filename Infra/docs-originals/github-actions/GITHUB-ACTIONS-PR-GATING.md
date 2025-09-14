GitHub Actions PR Gating — full guide (for non-experts)

Purpose

This guide explains how to gate pull requests using GitHub Actions to prevent IaC that makes S3 public or disables BPA from being merged.

Key concepts (plain English)
- Workflow: an automated set of steps run by GitHub Actions when a trigger occurs (e.g., a PR opens).
- Runner: a VM (hosted by GitHub) where the steps run.
- Job: a group of steps in a workflow that runs on a runner.
- Step: an individual action or command.
- Secret: an encrypted value stored in the GitHub repo settings (used for AWS credentials).

Step-by-step setup
1. Copy the provided workflow `docs/scenarios/SCENARIO-1.1/github-actions/ci-s3-security.yml` into `.github/workflows/ci-s3-security.yml`.
2. Create GitHub repository secrets for CI if the workflow needs to access AWS for plan/apply. Typical secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
3. Adjust the workflow path and commands if your terraform files live in another directory.
4. Open a PR and make a change that introduces a public ACL in Terraform. The workflow will run and should fail.

Managing workflows and monitoring
- View workflow runs in the GitHub UI under 'Actions'. Each run shows logs and job steps.
- For failing jobs, click into the failing step to read logs and identify the block causing failure.
- You can re-run workflows from the Actions UI for debugging.

Best practices for PR gating
- Keep workflows fast: run `terraform validate` and `plan` only — avoid `apply` in PRs.
- Use caching and selective paths to minimize CI minutes.
- Provide helpful error messages in the CI to guide the PR author (we included grep-based failure for ACLs).

Review process suggestions
- Configure branch protection rules on `lab-folio` to require passing status checks before merging.
- Require at least one reviewer for IaC changes.
- For sensitive changes (like SCP updates), require approvals from a security owner team.

Monitoring the pipeline
- Use GitHub Insights or third-party monitoring to track workflow durations, failures, and flakiness.
- Add a step to post results back to PR comments or to a Slack channel (via webhook) for visibility.

Troubleshooting tips
- If a step fails due to missing secrets, verify repo Settings → Secrets and check names.
- For terraform plan JSON parsing issues, check terraform version alignment between local and CI.

Operational modes
- Dry-run mode: set `DRY_RUN=1` in workflow environment to avoid remote pushes or costly operations.
- Full-run mode (for deploy branches): add a separate workflow that runs `apply` on a controlled branch with proper approvals.

Example PR flow for you (operator)
1. Create a branch: `git checkout -b feature/s3-config`
2. Make IaC changes in `docs/scenarios/SCENARIO-1.1/terraform` or your infra repo
3. Push branch and open PR targeting `lab-folio`
4. CI runs: If it fails, read the logs and fix the issue; if it passes and reviewers approve, merge.

