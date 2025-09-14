# Scenario 5: Security-compliant AWS Infrastructure - Overview

This folder contains runbooks and guides for designing workflows that provision security-compliant AWS infrastructure integrated with CI/CD (GitHub Actions), SBOM, SCA, image signing, runtime enforcement (Kyverno), and compliance mappings.

Files included:
- 00_overview.md — this file
- 01_prereqs_and_setup.md — prerequisites and bootstrap
- 02_architecture_and_workflows.md — high-level architecture, threat modeling
- 03_ci_cd_github_actions.md — GitHub Actions pipeline design and examples
- 04_sbom_sca_tools.md — Syft/Grype/Snyk/CycloneDX/SPDX guidance
- 05_terraform_integration_and_approval.md — Terraform integration and change approval patterns
- 06_testing_and_verification.md — unit/integration tests, gating, smoke tests
- 07_eks_and_kyverno.md — runtime enforcement and policies
- 08_compliance_mapping.md — SLSA/SSDF/CIS mapping and interview talking points

# Intent
Provide an end-to-end, non-destructive, WSL-compatible, secure-by-default blueprint you can use to build a portfolio project demonstrating SBOM, SCA, OIDC-based GitHub->AWS flows, signed images, and Kubernetes enforcement.
