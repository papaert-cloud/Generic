# Example: attach IAM policies to created roles

After running Terraform, review and attach only necessary managed policies. Example minimal inline policy for ECR push shown in `roles/ecr-push-policy.json`.

Consider using permission boundaries and least-privilege refinement as part of your PR review process.
