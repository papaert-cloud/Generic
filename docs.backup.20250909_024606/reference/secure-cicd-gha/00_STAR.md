# Scenario S003.000 — Secure CI/CD to AWS with GitHub Actions (no long-lived keys)

**Answer (STAR)**  
- **S:** Needed to deploy Terraform and apps to AWS without static secrets.  
- **T:** Implement OIDC federation for GitHub Actions and least‑privilege roles.  
- **A:** Created an IAM **OIDC provider** for GitHub; trust policy restricted to **repo / branch / environment**, short‑lived role sessions; added pipeline gates (fmt, tflint, Checkov, Conftest/OPA, Trivy/Snyk), **signed artifacts**, Terraform plan/apply with tfvars from secure store, plus **drift detection**.  
- **R:** Removed access keys, reduced blast radius, achieved clean audit trails and repeatable secure deployments.

**Refresher:** OIDC trust → audience & subject conditions → branch/environments pinning → pre‑merge security checks & attestation.
