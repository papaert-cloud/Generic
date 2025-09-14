# GitHub Actions - Super Workflows

This folder contains five high-impact, end-to-end CI/CD and DevSecOps pipeline templates you can adapt for real projects.

Structure:
- devops/
  - solution-01-ci-build-deploy/  # Standard CI/CD: build, test, push
  - solution-02-infra-approval/   # Terraform plan-as-artifact + gated apply (OIDC)
- devsecops/
  - solution-03-sbom-sca/         # SBOM generation (Syft) + SCA (Grype/Snyk) + gates
  - solution-04-image-signing-kyverno/ # cosign signing, ECR, Kyverno admission enforcement
  - solution-05-security-platform/ # Centralized findings, Security Hub (ASFF), S3 artifacts

Region: us-east-1
Accounts (examples provided): 005965605891, 058264377640 (OU: ou-im88-1fmr1yt9)

All templates use GitHub OIDC (no long-lived AWS keys), least-privilege IAM patterns, and encrypted S3 for artifacts.

Follow each solution's README for runbooks, commands, and implementation details.
