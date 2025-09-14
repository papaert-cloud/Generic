```markdown
# Deployment steps — StackSet via Terraform/Terragrunt

This file gives a concrete sequence to provision the OIDC provider, CI roles, and deploy a remediation Lambda as a CloudFormation StackSet using Terraform + Terragrunt. It assumes you have AWS CLI configured for the management account with permissions to create StackSets and assume roles.

Provided OU info (example to use when targeting deployment):
- OU Name: Lab-OU
- OU ID: ou-im88-1fmr1yt9
- OU ARN: arn:aws:organizations::005965605891:ou/o-3l9ybracw9/ou-im88-1fmr1yt9

High-level layout (suggestion):

```
infra/
  modules/
    oidc/
    remediation-lambda/
  live/
    platform/   # creates oidc provider and platform roles in management account
    stackset/    # creates CloudFormation StackSet packaging the lambda
Infra/environments/
  dev/
  staging/
  prod/
  sandbox/
  uat/
```

Concrete steps:

1. Implement module: `infra/modules/oidc`
   - Resource: `aws_iam_openid_connect_provider` for `token.actions.githubusercontent.com`.
   - Outputs: `oidc_provider_arn` and recommended `role_arn`.

2. Implement module: `infra/modules/remediation-lambda`
   - Use a `build/` stage to package Python code (zip with dependencies).
   - Resources: `aws_lambda_function`, `aws_iam_role`, minimal inline policy.

3. Create CloudFormation template for the lambda and any supporting resources, or use Terraform `aws_cloudformation_stack_set`.

4. Use Terragrunt in `Infra/environments/<env>/stackset` to deploy the stackset with `target_ou_ids = ["ou-im88-1fmr1yt9"]` or via `auto_deployment` settings.

5. Test in `sandbox` and `staging` before prod.

Example Terragrunt `terragrunt.hcl` snippet for stackset:

```hcl
terraform {
  source = "../../modules/stackset"
}

inputs = {
  stackset_name = "remediation-lambda-stackset"
  target_ou_ids = ["ou-im88-1fmr1yt9"]
}
```

Important notes:
- Creating StackSets across an OU may require delegated admin or management account privileges.
- Packaging and uploading lambda artifacts often requires an S3 bucket accessible by the StackSet.
- Do not run these steps on your machine unless AWS creds provided. Use CI with OIDC for automation.

```
