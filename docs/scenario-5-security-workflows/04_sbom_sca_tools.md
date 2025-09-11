# 04 - SBOM & SCA Tools (Syft, Grype, Snyk, CycloneDX/SPDX)

## SBOM formats
- CycloneDX: widely adopted in application security tooling, good for CycloneDX ecosystem
- SPDX: popular in OSS/package-license context

## Tooling
- Syft: generates SBOMs from images or directories. Example:
# syft registry.example.com/myapp:latest -o cyclonedx-json=sbom.cyclonedx.json

- Grype: vulnerability scanner that can scan images or SBOMs
# grype sbom:sbom.cyclonedx.json -o json > grype.json

- Snyk: SaaS SCA with richer vulnerability DB and PR-level fixes

## Image signing (cosign)
- Generate keys in GitHub Actions using OIDC + KMS or GitHub Secrets for private keys (prefer KMS)
- Sign images:
# cosign sign --key <kms://...> registry.example.com/myapp:tag

## SBOM consumption
- Store SBOM artifacts in S3 (encrypted, versioned) and/or attach to image metadata
- Use SBOM to drive policy decisions (Kyverno admission requiring sbom-validated=true)

## Scripts
- Include small scripts to convert grype results to ASFF for Security Hub ingestion.

## Interview talking points
- Explain why CycloneDX over SPDX in certain contexts
- Show an example SBOM and how to trace a vulnerable transitive dependency to source
