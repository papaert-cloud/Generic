# 02 - Architecture & Workflows

## Goals
- Rapid, consistent provisioning of secure AWS environments via IaC
- Security gates in CI: SAST, SBOM, SCA, container scan, cosign signature verification
- Runtime enforcement in Kubernetes using Kyverno
- Centralized findings (ASFF -> Security Hub or central S3/Elasticsearch)

## High-level components
- Developer commits -> GitHub Actions
- Pipeline jobs: unit tests -> build image -> syft SBOM -> grype/Snyk SCA -> cosign sign -> push image to ECR -> terraform plan/apply (via OIDC role)
- Post-scan: findings converted to ASFF and pushed to Security Hub or S3
- Interactive/manual DAST (OWASP ZAP/Burp) in pre-release or QA stages

## Threat-model highlights
- Supply chain: signed images, SBOM provenance, pinned base images
- CI compromise: GitHub OIDC, ephemeral creds, least-privilege IAM
- Runtime: enforce policies to block unsigned/non-compliant images

## Workflow diagram (text)
1. PR opened -> Actions runs pre-merge checks: SAST (linters), unit tests, SBOM + SCA
2. If pass -> build image artifact, run container scan (grype), sign image with cosign
3. Push to registry (ECR) and record SBOM in S3 artifact bucket
4. Create Terraform plan (in PR) — plan output stored as artifact
5. Approval gate (manual or GitHub CODEOWNERS / protected branches) -> apply using OIDC role
6. Post-deploy: run DAST against staging, Kyverno enforces policies in cluster

## Notes on approvals
- Use separate approval layer for infra changes (recommended). Terraform runs can be automated but apply should run with human approval or automation guardrails (change windows, chatops approvals).
