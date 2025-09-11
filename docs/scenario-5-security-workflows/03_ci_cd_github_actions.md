# 03 - CI/CD (GitHub Actions) Pipeline Guide

## Pipeline stages (recommended)
- pre-commit hooks (local): lint, go vet, bandit, etc.
- PR checks: SAST, unit tests, SBOM generation, SCA vulnerability scan
- Build and sign: docker build -> syft -> grype -> cosign sign -> push ECR
- Infra: terraform fmt/validate -> terraform plan (artifact) -> manual approval -> terraform apply (OIDC)
- Post-deploy: DAST (OWASP ZAP), export findings to S3/Security Hub

## Example job snippets (conceptual, not full YAML)
- SBOM generation (Syft):
# syft <image> -o cyclonedx-json=function output SBOM in CycloneDX JSON

- Grype scan:
# grype <image_or_sbom> -o json > grype.json

- Convert to ASFF (example script):
# python scripts/grype_to_asff.py --input grype.json --output findings.json

- Terraform run using OIDC:
# uses: aws-actions/configure-aws-credentials@v2
# with role-to-assume: arn:aws:iam::123456789012:role/github-oidc-terraform

## Severity gating
- Implement a gate that fails the workflow if grype finds any HIGH or CRITICAL vulnerabilities (configurable via input)

## Storage
- Save SBOM and scan reports as build artifacts and upload a copy to the secure S3 bucket with server-side encryption and versioning.

## Notes
- Provide reusable composite actions for SBOM/SCA/convert-to-ASFF steps.
- Avoid storing any AWS secrets — use OIDC.
