# DevOps Solution 01 — CI / Build / Deploy (High-impact)

Situation
An engineering org needs a fast, repeatable CI pipeline that runs unit tests, builds Go binaries, builds container images, and deploys to staging — with artifact storage and basic security hygiene.

Goal
Deliver a production-ready CI that is easy for teams to adopt and demonstrates clean build provenance and repeatable deploys.

Implementation (end-to-end)
1. Developer opens PR -> GitHub Actions `ci-build-deploy.yml` triggers.
2. Steps: checkout -> setup Go -> unit tests -> build binary -> containerize (distroless) -> SBOM (syft) -> image push to ECR via OIDC role -> upload SBOM to S3.
3. Deployment: simple Terraform module for staging that pulls container from ECR and deploys to ECS/Fargate or EKS.

Key files
- `.github/workflows/ci-build-deploy.yml` (already created)
- `scripts/build_and_push.sh` — builds image, creates SBOM
- `terraform/` module that creates ECR and staging infra

Evidence package (what to collect per run)
- `artifacts/sbom.cyclonedx.json`
- `artifacts/build-metadata.json` (image digest, tag, build time)
- `terraform/plan.json` for infra changes

Tests & gates
- Unit tests must pass
- Image must be scanned for critical vulnerabilities (see DevSecOps solution)

Run commands (WSL)
```bash
# validate terraform
cd github-actions/devops/solution-02-infra-approval/terraform
terraform init
terraform plan -var-file=terraform.tfvars

# run build locally
./github-actions/devops/solution-01-ci-build-deploy/scripts/build_and_push.sh --tag localtest
```

Risks & mitigations
- Risk: leaked creds in CI — Mitigation: GitHub OIDC + least-priv role
- Risk: unscanned images — Mitigation: integrate SBOM + Grype pipeline (see DevSecOps)

Why this is DevOps (not DevSecOps)
- Focused on release velocity, reproducible builds, and operational deployment. Security hygiene is included but heavy scanning/signing/enforcement are in DevSecOps solutions.
