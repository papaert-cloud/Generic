# Terraform example for Scenario 2

This directory contains a minimal example to create a KMS key, S3 bucket and an Organization CloudTrail. It must be run from the management (organization) account.

Important cautions

- Do not run these examples against production without reviewing the values, ARNs, and IAM policies.
- Review `variables.tf` and replace `s3_bucket` and other defaults.

Quick commands

```bash
cd docs/scenarios/SCENARIO-2/terraform
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
# Terraform example for Scenario 2

This directory contains a minimal example to create a KMS key, S3 bucket and an Organization CloudTrail. It must be run from the management (organization) account.

Important cautions

- Do not run these examples against production without reviewing the values, ARNs, and IAM policies.
- Review `variables.tf` and replace `s3_bucket` and other defaults.

Quick commands

```bash
cd docs/scenarios/SCENARIO-2/terraform
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

To destroy (test accounts only):

```bash
terraform destroy -auto-approve
```
