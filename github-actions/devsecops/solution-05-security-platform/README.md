# Solution 05 — Centralized Security Platform (DevSecOps)

Purpose: Centralize findings (ASFF) to AWS Security Hub, store artifacts in S3, and demonstrate automated ingestion and dashboards.

Key features:
- Convert Grype/Snyk outputs into ASFF and BatchImportFindings to Security Hub
- Store SBOMs, scan reports, and pipeline artifacts in an encrypted, versioned S3 bucket
- Use EventBridge/Step Functions to trigger enrichment (e.g., CVE metadata) and run post-processing
- Provide evidence packages for compliance (SLSA/SSDF/CIS mappings)

Files included:
- `.github/workflows/scan-to-securityhub.yml` (example)
- `scripts/grype_to_asff.py` (converter)
- `terraform/security-platform/` (scaffold for Security Hub, S3, KMS)

Notes: Security Hub requires permissions for BatchImportFindings. For demo, you can simulate import by saving ASFF to S3.
