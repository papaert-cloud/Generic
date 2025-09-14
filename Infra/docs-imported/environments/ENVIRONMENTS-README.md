
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

	infra/modules/&lt;module&gt;
	infra/live/&lt;env&gt;/&lt;service&gt;/terragrunt.hcl

- When copying `dev` to a new env, update `remote_state` configuration and any `dependencies` that point to other env modules.

## Secrets and sensitive variables

- Never check plaintext secrets into git. Use SSM Parameter Store, Secrets Manager, or your CI secret store.
- In Terraform, prefer data sources to fetch secrets at runtime, or inject secrets via CI environment variables.

## Guardrails and testing

- Implement pre-commit or CI checks that run `terraform validate` and module unit tests (if used).
- Add a small smoke test suite per environment that can verify key resources (VPC exists, IAM role can be assumed, S3 bucket policy is correct).
- Keep a `sandbox` environment dedicated to integration testing. Do not use `dev` as your staging test-bed.

## Notes

- Keep runbooks and operational docs in `/docs` (runbooks, scenario write-ups, playbooks). Keep the infra code and environment tfvars in `/Infra/environments/`.
- This repository follows the principle of separating infrastructure code (Infra/) from human-facing documentation (docs/).

## Port checklist (quick)

- [ ] Review modules & provider configs in `dev`.
- [ ] Create `terraform.tfvars` for target env.
- [ ] Update Terragrunt `remote_state` and `dependencies`.
- [ ] Update CI assume-role ARNs for target account.
- [ ] Run plan in `sandbox`.
- [ ] Promote to `staging`, then `prod` after verification.

