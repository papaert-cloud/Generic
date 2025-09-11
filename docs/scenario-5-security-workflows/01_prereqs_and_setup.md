# 01 - Prerequisites & Setup

## Local / WSL prerequisites
- Git (git)
- AWS CLI v2 (configured for an admin/user for bootstrap only)
- Terraform 1.5+ (or pinned per module)
- Docker (for local image build, Syft/Grype scans)
- syft (SBOM generator) — https://github.com/anchore/syft
- grype (vuln scanner) — https://github.com/anchore/grype
- cosign (image signing) — https://github.com/sigstore/cosign
- snyk (optional SaaS SCA) or local SCA tools
- kubectl, eksctl (if using EKS demo)

## GitHub / Cloud prerequisites
- GitHub repo with Actions enabled
- GitHub OIDC enabled in AWS trust relationship (no long-lived keys)
- S3 bucket for artifacts with encryption and versioning enabled
- Security Hub enabled (or simulated import via ASFF)
- AWS IAM role(s) for GitHub OIDC with narrow, least-privilege policies

## Recommended local installs (WSL example commands)
# install example (Ubuntu/WSL):
# sudo apt update && sudo apt install -y git curl unzip docker.io
# Install syft/grype/cosign via their release pages or `brew` on WSL if using Linuxbrew

## Notes
- Never hardcode secrets — use GitHub Actions OIDC and AWS Secrets Manager/SSM for runtime secrets.
- Pin versions in CI to ensure reproducible SBOMs and scans.
