# 08 - Compliance Mapping: SLSA / SSDF / CIS

## Mapping highlights
- SLSA: Focuses on provenance, signed artifacts, verified builds (we demonstrate with syft/cosign and OIDC)
- SSDF: Secure Software Development Framework — integrate SAST, SCA, manual code review, and supply chain controls
- CIS: Benchmark recommendations for hardened OS and Kubernetes control plane

## Example mapping entries
- Requirement: Signed build artifacts -> Implementation: cosign-signed images, SBOM stored in S3 -> SLSA level: 2/3
- Requirement: Short-lived creds -> Implementation: GitHub OIDC -> SSDF: Identity and Auth Controls

## Interview talking points
- Explain ASFF and why it's useful for Security Hub ingestion
- Describe trade-offs between pushing findings to Security Hub vs. storing in S3 + ElasticSearch

## Next steps
- Add a table mapping each requirement to evidence artifacts and verification steps
