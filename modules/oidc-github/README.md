# Terraform module: oidc-github

Reusable module to provision (or reference) a GitHub Actions OIDC provider and create IAM roles that GitHub can assume via OIDC.

Features
- Optionally create the `aws_iam_openid_connect_provider` (set `create_oidc_provider = true`) or reference an existing provider by `account_id`.
- Create an IAM role with assume-role policy restricted to a specific `owner/repo` or pattern.
- Optionally attach an S3 put-object policy or other policies.

Usage example
```hcl
module "github_oidc" {
  source = "../../modules/oidc-github"

  create_oidc_provider = false # set to true only if you want the module to create the provider
  account_id            = "005965605891"
  aws_region            = "us-east-1"
  github_repo           = "papaert-cloud/Generic"
  role_name             = "GitHubActionsOIDCRole"
  github_sub_suffix     = "*"

  # Optional: attach an existing policy ARN or let module create a policy for S3
  attach_s3_bucket      = "my-org-artifacts"
}
```

Outputs
- `oidc_provider_arn` - ARN of the OIDC provider (existing or created)
- `role_arn` - ARN of the created IAM role
- `role_name` - name of the role

Security notes
- Prefer `create_oidc_provider = false` if an OIDC provider already exists in the account.
- Scope `github_repo` and `github_sub_suffix` to minimize which workflows/refs can assume the role.

Optional policy attachments
---------------------------
This module now supports optionally attaching additional least-privileged policies to the created role. Set the corresponding variables at module instantiation to enable each capability:

- `attach_s3_bucket` (string) — allows `s3:PutObject` and `s3:PutObjectAcl` to the specified bucket for artifact uploads.
- `attach_ecr_repositories` (list(string)) — provide ECR repository ARNs (or names, depending on your usage) to allow push/pull actions required for `docker push`/`docker pull` or `aws ecr` workflows.
- `attach_kms_key_arns` (list(string)) — a list of KMS key ARNs the role may use for signing or encryption operations (actions: `kms:Encrypt`, `kms:Decrypt`, `kms:GenerateDataKey*`, `kms:Sign`, `kms:Verify`).
- `enable_securityhub` (bool) — when `true` attaches minimal Security Hub permissions used by scanning workflows to import findings.
- `attach_terraform_state_bucket` (string) — grants S3 read/write and listing permissions necessary for remote Terraform state in an S3 backend.
- `attach_tfstate_dynamodb_table` (string) — grants DynamoDB Get/Put/Delete/Update permissions for Terraform state locking when you are using a DynamoDB lock table.

Usage tip: only enable the variables your workflows require and scope resources (ARNs/bucket names/table names) as narrowly as possible to follow the principle of least privilege.

## Duplicate outputs note

This module keeps all Terraform `output` definitions in `outputs.tf`. If you previously saw a "Duplicate output definition" error during `terraform init`, it's because output blocks were accidentally declared in `main.tf` as well. Those were removed to avoid the conflict.

## Importing an existing OIDC provider (when you want Terraform to manage it)

If an OIDC provider for `token.actions.githubusercontent.com` already exists in your AWS account and you want this module to manage it, import the provider into the module-managed resource before running `terraform apply`.

Replace `ACCOUNT_ID` with your AWS account id and run from your Terraform root directory:

```bash
terraform init
terraform import module.github_oidc.aws_iam_openid_connect_provider.maybe_create[0] arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com
terraform plan
terraform apply
```

Notes:

- If you set `create_oidc_provider = false` the module references the existing provider and you do not need to import it.
- After import, `terraform plan` should show no changes for the provider resource if the module's `client_id_list` and `thumbprint_list` match the existing provider; otherwise plan may propose updates.
