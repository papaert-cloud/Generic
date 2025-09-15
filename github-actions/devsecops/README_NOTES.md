# DevSecOps notes & quick checklist

- Pin syft/grype/cosign versions in CI to ensure reproducible SBOMs and scans.
- Ensure S3 buckets have server-side encryption and access logging enabled.
- Configure GitHub branch protections and require status checks: sbom-sca, terraform-plan.
- Avoid storing raw KMS keys in GitHub secrets; prefer granting roles and using KMS ARNs in workflows.
