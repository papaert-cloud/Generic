# Next steps to finalize Terraform roles (manual actions)

1. Create OIDC provider in each account (if not present). Example console path: IAM -> Identity providers -> Add provider.
2. Create role trust policies (see `roles/oidc-trust-policy.json`) and restrict `sub` claim to your repo/branch.
3. Replace placeholders in `terraform.tfvars` and run `terraform apply` in a dedicated admin sandbox.
4. Review IAM policies and tighten resource ARNs instead of wildcard `*` before production.

If you want, I can generate a GitHub Actions workflow to drive role creation via Terraform Cloud/runner, but that requires elevated bootstrap credentials.
