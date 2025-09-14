# Solution 01 — CI / Build / Deploy (DevOps)

Purpose: A pragmatic CI pipeline for application teams: unit tests, build, container image build & push, and deployment to a staging environment.

Key features:
- Build and test stages
- Docker image build and push to ECR
- Use GitHub Actions OIDC to push to ECR (no static creds)
- Artifact storage: SBOM & image metadata saved to S3
- Minimal Terraform scaffold to create ECR and staging resources

Prereqs:
- GitHub repo `sbom-security-pipeline`
- AWS accounts: 005965605891 / 058264377640
- S3 artifact bucket (encrypted & versioned)
- IAM role for GitHub OIDC to push images

Files included:
- `.github/workflows/ci-build-deploy.yml` (example pipeline)
- `scripts/build_and_push.sh` (builds image, generates SBOM)
- `terraform/` (scaffold to create ECR + S3)

Next steps: customize image name, repository, and environment variables according to your org naming standards.
