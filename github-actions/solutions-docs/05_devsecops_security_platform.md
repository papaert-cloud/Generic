# DevSecOps Solution 05 — Centralized Security Platform (High-impact)

Situation
Multiple scanners and pipelines produce diverse outputs; security teams need a central place to search, triage, and act on findings.

Goal
Ingest scanner outputs (Grype, Snyk, Trivy, OWASP ZAP) into a central system: Security Hub (ASFF) and S3 for raw artifacts; link findings to tickets and remediation workflows.

Architecture
- CI produces SBOM and scan artifacts -> converter scripts create ASFF -> Security Hub `BatchImportFindings` ingests findings -> Lambda/Step Functions enrich findings (CVE metadata) -> findings surface in a dashboard (Security Hub insights or custom Kibana).

Pipeline
1. `sbom-sca.yml` finishes -> triggers `scan-to-securityhub.yml` which downloads artifacts and runs `grype_to_asff.py`.
2. The workflow assumes a role with `securityhub:BatchImportFindings` and calls the AWS CLI or boto3 to import.
3. An EventBridge rule picks up Security Hub events for automated ticket creation (Jira/ServiceNow) on HIGH/CRITICAL.

Evidence package
- ASFF JSON
- Raw scanner outputs
- Enrichment logs and remediation links

Controls & Governance
- Ensure Security Hub is enabled in account and hub member accounts configured if multi-account
- Use KMS encryption for artifacts and S3 bucket access logs for audit

Commands (WSL)
```bash
python3 github-actions/devsecops/solution-05-security-platform/scripts/grype_to_asff.py --input artifacts/grype.json --output artifacts/asff.json
aws securityhub batch-import-findings --findings file://artifacts/asff.json --region us-east-1
```

Interview talking points
- CVE vs CVSS: CVE is an identifier; CVSS provides severity scoring; triage uses both plus exploitability and business context.
- How ASFF maps scanner fields to Security Hub fields and why that matters for triage automation.
