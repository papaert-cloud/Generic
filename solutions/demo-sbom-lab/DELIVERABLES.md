# Deliverables — Demo SBOM Lab

This file lists tangible items you can show in interviews and how to produce them.

Tangible deliverables
- Live SBOM file (syft JSON) for the demo image or repo.
- Vulnerability report (Trivy JSON) and a short summary (top 5 CVEs).
- S3 objects with SBOM + scan report (show bucket path).
- Security Hub findings (screenshots and a small exported JSON of ingested findings).
- CI run screenshot (GitHub Actions run showing OIDC step and workflow passing).
- Kyverno policy pass/fail screenshot (policy name and the resource it checked).

How to capture screenshots
- Security Hub: open the finding and capture the console view; place images into `assets/screenshots/securityhub-*.png`.
- GitHub Actions: open the run and capture: `assets/screenshots/gha-*-oidc.png`.

Sample results directory layout
- `output/sbom.json`
- `output/scan.json`
- `output/securityhub-findings.json`

Checklist for interview
- [ ] SBOM generated for demo image
- [ ] Scan results produced and summarized (top N vulns)
- [ ] Artifacts uploaded to S3 (show object URL)
- [ ] Security Hub ingestion validated (screenshot)
- [ ] CI screenshot showing OIDC role step
- [ ] Kyverno policy screenshot
