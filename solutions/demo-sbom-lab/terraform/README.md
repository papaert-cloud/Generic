This folder contains a template Terraform file `iam-role.tf` demonstrating a minimal IAM role to allow GitHub Actions OIDC to assume a role.

Before using:
- Replace `<owner>/<repo>` in the trust policy with your repository.
- Set `aws_account_id` when running `terraform apply`.
- Limit the role's permissions to a narrow set (S3 PutObject, SecurityHub:BatchImportFindings, etc.) in a separate `aws_iam_policy` and attached role policy.

Example:
  terraform init
  terraform plan -var='aws_account_id=123456789012'
  terraform apply -var='aws_account_id=123456789012' -auto-approve
