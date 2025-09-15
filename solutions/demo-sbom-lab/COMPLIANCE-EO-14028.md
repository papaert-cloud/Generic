# EO 14028 alignment — Compliance mapping (demo lab)

This document maps the demo SBOM pipeline to key expectations from EO 14028 (Executive Order on Improving the Nation's Cybersecurity) and related guidance.

Scope: this is a concise mapping to help you explain design choices during interviews. It's not an exhaustive audit.

Mapping
- SBOM generation
  - EO goal: improve software transparency and supply chain visibility.
  - Demo evidence: `output/sbom.json` produced by `syft`.
  - Controls: reproducible SBOM generation, signed SBOM when applicable.

- Vulnerability scanning
  - EO goal: detect and remediate known vulnerabilities early.
  - Demo evidence: `output/scan.json` (Trivy) and CI job that fails on high severity.
  - Controls: baseline severity thresholds, triage process.

- Artifact storage and access control
  - EO goal: secure storage of build artifacts and provenance.
  - Demo evidence: S3 upload with least-privilege role (GitHub OIDC) and bucket with encryption + access logging.
  - Controls: enforce encryption, immutable storage lifecycle for evidence, IAM role trust with limited privileges.

- Telemetry and integration with central security services
  - EO goal: centralized telemetry and incident/alerting integration.
  - Demo evidence: Security Hub import of findings (or AWS Security Hub integration shown as a screenshot) showing consolidated findings.
  - Controls: mapping of vulnerability findings to Security Hub schema, tagging, and automation to open tickets.

- Policy enforcement
  - EO goal: enforce security policy in CI/CD and runtime.
  - Demo evidence: Kyverno policy examples and a CI gate that runs policy checks.
  - Controls: defined policy rules for disallowed images, vulnerability thresholds, provenance requirements.

How to speak to this in interviews
- Walk through the five steps above with artifacts from `DELIVERABLES.md`.
- Show the GitHub Actions workflow and explain OIDC usage: `permissions: id-token: write` and role assumption.
- Explain how you would extend this to sign SBOMs and to include provenance assertions (e.g., Sigstore/Cosign) for stronger supply chain guarantees.

Next improvements (non-blocking)
- Add SBOM signing (cosign) and verification as part of the pipeline.
- Automate Security Hub ingestion with the correct finding mapping and IAM perms.
- Add automated remediation tickets via Lambda or EventBridge rules when high-severity items appear.
