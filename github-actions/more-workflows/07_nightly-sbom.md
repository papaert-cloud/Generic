# Nightly SBOM Rescan

Purpose: Re-scan images daily to catch newly disclosed CVEs for previously scanned SBOMs.

Process:
- Enumerate latest images/tags
- Run syft + grype, upload diffs to S3
- Alert on newly discovered HIGH/CRITICAL
