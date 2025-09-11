# Compliance Mapping (SLSA / SSDF / CIS) — Quick Reference

This file provides a short mapping of pipeline controls to compliance artifacts.

- Signed artifacts: cosign + SBOM stored in S3 -> SLSA provenance & SSDF build integrity
- Short-lived creds: GitHub OIDC -> SSDF identity controls
- IaC checks: checkov/tflint -> CIS / NIST IaC controls mapping
- Evidence packaging: store plan.json + SBOM + grype.json in S3 under evidence/<run-id>

Use this doc to craft interview-ready talking points and evidence artifacts for audits.
