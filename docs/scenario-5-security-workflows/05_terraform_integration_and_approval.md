# 05 - Terraform Integration & Change Approval

## Patterns
- Plan-as-code: run `terraform plan` in CI and upload plan JSON as an artifact
- Prevent automatic `apply` on unreviewed plans — require manual approval (GitHub PR review or specific approvers)
- GitHub OIDC to assume an IAM role that is allowed to `terraform apply` in target accounts

## Recommended IAM approach
- Create a narrowly scoped role per environment with only required actions (e.g., ec2:create, iam:passrole only when needed)
- Trust policy for GitHub OIDC includes repository and job aud claim

## Approvals
- Option A (recommended): Terraform plan is created in PR; human reviewer approves and trigger `apply` job with environment protection
- Option B (automated): Use policy-as-code to auto-approve trivial changes; major changes require manual approval

## Example GitHub Actions snippet (conceptual)
# - name: Terraform Plan
#   uses: hashicorp/terraform-github-actions@v1
# - name: Upload plan
#   uses: actions/upload-artifact
# - name: Terraform Apply (protected)
#   if: github.event.inputs.approve == 'true'
#   uses: hashicorp/terraform-github-actions@v1

## Definition of Done for Infra change
- Plan executed and reviewed
- No HIGH/CRITICAL security findings in infra-related scans
- Secrets not leaking in plan outputs
- Automated tests (integration/smoke) passed in staging

## Tests
- Use `terraform validate`, `tflint`, `checkov` for IaC static security checks
- Use drift detection post-apply via periodic runs
