# DevSecOps Solution 03 — SBOM Generation & SCA (High-impact)

Situation
Supply chain attacks and transitive vulnerabilities require automated SBOM production and SCA during CI to catch risky dependencies early.

Goal
Generate CycloneDX SBOMs for every build, scan them with Grype (and optionally Snyk), fail PRs on HIGH/CRITICAL CVEs, and store artifacts as evidence.

Architecture
- CI builds image -> Syft generates CycloneDX JSON -> Grype scans SBOM -> converter transforms findings to ASFF -> push to Security Hub (or S3 evidence bucket).

Pipeline (code-to-prod)
1. `sbom-sca.yml` runs on PR.
2. Build image -> syft -> grype -> `check_grype_severity.py` enforces threshold.
3. Artifacts (`sbom.cyclonedx.json`, `grype.json`) uploaded and copied to S3 for audit.

Tests & Validation
- Unit tests for `check_grype_severity.py` and `grype_to_asff.py` (example tests included in repo under `tests/` optionally).
- Nightly re-scan jobs to detect newly disclosed CVEs.

Evidence package
- `sbom.cyclonedx.json`
- `grype.json` with vulnerability matches
- ASFF JSON pushed to Security Hub

Commands (WSL)
```bash
# local SBOM + scan
docker build -t app:local .
syft app:local -o cyclonedx-json=./artifacts/sbom.json
grype sbom:./artifacts/sbom.json -o json > ./artifacts/grype.json
python3 github-actions/devsecops/solution-03-sbom-sca/scripts/check_grype_severity.py ./artifacts/grype.json --threshold HIGH
```

Interview talking points
- CycloneDX vs SPDX: CycloneDX better for app security tooling and richer vulnerability metadata; SPDX is license-focused.
- ASFF: standard schema for Security Hub ingestion; converts scanner outputs into a central view.
