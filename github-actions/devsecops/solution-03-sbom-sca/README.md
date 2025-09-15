# Solution 03 — SBOM + SCA Pipeline (DevSecOps)

Purpose: Demonstrate automated SBOM generation (Syft), SCA scanning (Grype/Snyk), and severity gating in CI.

Key features:
- Syft to generate CycloneDX SBOMs
- Grype to scan SBOMs or images
- Severity gate: fail if HIGH/CRITICAL findings exist (configurable)
- Save SBOMs and scan reports as artifacts and upload to S3 (encrypted)
- Convert Grype findings into ASFF JSON for Security Hub ingestion

Files included:
- `.github/workflows/sbom-sca.yml` (pipeline example)
- `scripts/generate_sbom.sh`
- `scripts/scan_grype.sh`
- `scripts/grype_to_asff.py` (converter stub)

Notes: This solution favors reproducible SBOMs: pin Syft/Grype versions and set deterministic image tags.
