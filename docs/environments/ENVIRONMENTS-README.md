
# Environment tree and porting guide

Environments (logical folders):
- dev (current implementation)
- staging
- prod
- sandbox
- uat

## Overview

This document explains how the environment folders are organized, how to port infrastructure code from `dev` to other environments, and gives concrete examples (terraform/tfvars, Terragrunt layout, and guardrails).

# Environment tree and porting guide

Environments (logical folders):

- dev (current implementation)
- staging
- prod
- sandbox
- uat

## Overview

This document explains how the environment folders are organized, how to port infrastructure code from `dev` to other environments, and gives concrete examples (terraform/tfvars, Terragrunt layout, and guardrails).

## Environment structure (recommended)

Infra should host the infrastructure code and environment-specific tfvars. A simple layout:

Infra/
	environments/
		dev/
			terraform.tfvars (or terraform.tfvars.example)
		staging/
		prod/
		sandbox/
		uat/

Docs and narrative content (runbooks, runbooks for incidents, SOPs) should live in the repository `docs/` folder so they are easily discoverable by non-infra audiences.

## How to port from `dev` to another environment (concrete steps)

1. Review IaC and variables used in `dev` (modules, providers, backend configuration, and any hard-coded account IDs).
2. Create a new `terraform.tfvars` (or `terraform.tfvars.example`) for the target environment and set values such as account IDs, role ARNs, region, and any prefix/suffix values.

   - Example snippet (`terraform.tfvars`):

	  account_id = "123456789012"
	  region     = "us-west-2"
	  env        = "staging"
	  s3_state_bucket = "company-terraform-state-us-west-2"

3. For Terragrunt users: copy the `dev` folder under `Infra/environments/` to the new env folder and update the `remote_state` backend and `dependencies` blocks to point to the correct state bucket and account/region.

   - Update the `backend` (S3 bucket/key) and KMS key ARNs in the remote_state configuration.
4. Update IAM roles/policies used by CI or automation to allow assume-role into the target environment account.
5. Run a plan in a `sandbox` or ephemeral test environment first. Validate resources, outputs and any cross-account references.
6. After testing, apply in `staging` and run smoke tests, then schedule and apply in `prod`.

## Examples and templates

Example `terraform.tfvars` (dev -> staging example):

	# terraform.tfvars
	account_id       = "111111111111"    # dev account
	region           = "us-east-1"
	env              = "dev"
	s3_state_bucket  = "org-terraform-state-us-east-1"
	kms_key_arn      = "arn:aws:kms:us-east-1:111111111111:key/xxxx"

When porting to `staging` update the values appropriately:

	account_id       = "222222222222"    # staging account
	region           = "us-west-2"
	env              = "staging"

## Terragrunt notes

- Keep a small `terragrunt.hcl` per environment that references a common module directory. Example:
# Environment tree and porting guide

This document clarifies how environment folders are organized and shows concrete, copy-pasteable examples for porting infrastructure from `dev` to higher environments using Terraform and Terragrunt.

Environments (recommended)

- dev (development & active authoring)
- sandbox (integration testing, run smoke tests)
- staging (pre-prod validation)
- uat (user acceptance testing)
- prod (production)

Why separate environments?

- Clear separation reduces blast radius.
- Allows different guardrails, account IDs, and remote state.
- Easier promotion/testing channels (dev -> sandbox -> staging -> prod).

Where to put what

- `Infra/` should contain the actual IaC (Terraform modules, Terragrunt live layouts, and CloudFormation templates).
- `docs/` should contain runbooks, SOPs, scenario playbooks, and user-facing documentation.
- Keep example `terraform.tfvars.example` files in `Infra/environments/<env>/` to show required variables for each environment.

Recommended layout (example)

Infra/
	modules/
	live/
		dev/
			<service>/
		sandbox/
		staging/
		uat/
		prod/

docs/
	environments/
		ENVIRONMENTS-README.md
		dev.md
		staging.md
		prod.md

Concrete steps to port from `dev` to another environment

1. Create a new environment directory under `Infra/live/<env>` by copying `dev` as a starting point.

2. Update backend/remote_state and provider configuration in your Terragrunt or Terraform files. Example Terragrunt remote state snippet (`terragrunt.hcl`):

```hcl
remote_state {
	backend = "s3"
	config = {
		bucket         = "org-terraform-state-us-east-1"
		key            = "<team>/<service>/terraform.tfstate"
		region         = "us-east-1"
		encrypt        = true
		dynamodb_table = "org-terraform-locks"
	}
}
```

3. Create `terraform.tfvars` or `terraform.tfvars.example` for the new env with correct account IDs, region, and resource prefixes. Example `terraform.tfvars` values:

```hcl
account_id      = "222222222222"
region          = "us-west-2"
env             = "staging"
s3_state_bucket = "org-terraform-state-us-west-2"
kms_key_arn     = "arn:aws:kms:us-west-2:222222222222:key/xxxx"
```

4. Update CI assume-role ARNs in your pipeline configuration to allow your CI runner (GitHub Actions) to assume deployment roles in the target account.

5. Run `terragrunt plan` in `sandbox` and run smoke tests. If green, promote to `staging` and finally `prod` with scheduled change windows.

Examples: Terragrunt -> Terraform -> CloudFormation StackSet deployment

Use case: Deploy a CloudFormation StackSet that ensures an auto-remediation Lambda exists in multiple accounts (useful for enforcing guardrails like public S3 block or security group fixes).

- Build & upload Lambda: Package your Lambda code and upload to a secure S3 bucket (private). Example using AWS CLI:

```bash
aws s3 cp ./lambda/remediate.zip s3://my-deployment-bucket/remediate/remediate.zip --acl private --region us-east-1
```

- Configure Terragrunt inputs for the environment to point to the S3 bucket and target accounts (see `Infra/solutions/scenario-s003-000-secure-cicd-gha/terragrunt.hcl` for an example).

- Run Terragrunt from the environment folder:

```bash
cd Infra/solutions/scenario-s003-000-secure-cicd-gha
terragrunt init
terragrunt apply
```

Notes on sensitive data and secrets

- Keep secrets out of Terraform files. Use CI secrets (GitHub Actions secrets), SSM Parameter Store, or Secrets Manager.
- Use data sources to fetch secrets at runtime, or pass them as environment variables from CI.

Quick port checklist

- [ ] Copy `dev` to the new `Infra/live/<env>` folder
- [ ] Update remote_state/backend config
- [ ] Create `terraform.tfvars` for the env
- [ ] Update CI assume-role entries and test access
- [ ] Plan & apply in `sandbox`, validate, then promote

Further reading and references

- See `Infra/solutions/scenario-s003-000-secure-cicd-gha/README.md` for a worked example of a StackSet-driven remediation solution.

