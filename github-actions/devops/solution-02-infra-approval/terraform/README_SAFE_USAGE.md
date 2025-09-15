# Safe usage notes

- Always run `terraform plan` and upload plan.json to artifact storage for reviewers.
- Use separate state backends per environment (prod/staging/dev) and lock them via DynamoDB locks.
- Use IAM conditions and resource scoping in policies before applying to production.
