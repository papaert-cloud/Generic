Work-area breakdown — 2025-09-11

This file breaks down the work into identifiable concept areas and lists the concrete solutions, commands, issues and recommended next steps for each.

1) Documentation & repo organization

Concept
- Provide a single entrypoint that tells the story and links to demo artifacts.

Solution
- `solutions/demo-sbom-lab/README.md` — quickstart and contract.
- `recap/README.md` and this work-area file.

Commands & files
- Edit README locally; commit to repo.

Issues
- MD lint warnings for list spacing and H1s.

Next steps
- Fix MD linting and add a small TABLE OF CONTENTS for the demo README.

2) SBOM generation and scanning

Concept
- Generate SBOMs for built artifacts and scan for vulnerabilities.

Solution
- `scripts/generate-sbom.sh` (syft), `scripts/scan-sbom.sh` (trivy).

Commands
```bash
./solutions/demo-sbom-lab/scripts/generate-sbom.sh <image-or-dir> ./output/sbom.json
./solutions/demo-sbom-lab/scripts/scan-sbom.sh ./output/sbom.json ./output/scan.json
```

Issues
- Dependence on host-installed syft/trivy. For CI, install as part of runner or use prebuilt images.

Next steps
- Build lightweight container that bundles syft+trivy for reproducible runs.

3) CI: OIDC & GitHub Actions

Concept
- Use GitHub OIDC to assume AWS roles; avoid stored AWS keys.

Solution
- `.github/workflows/demo-sbom-pipeline.yml` with `permissions: id-token: write` and instructions to use `aws-actions/configure-aws-credentials`.
- `terraform/iam-role.tf` template shows trust policy.

Commands & snippets
- In workflow: `syft . -o json > output/sbom.json`
- In workflow: `trivy filesystem --format json -o output/scan.json . || true`

Issues
- Need to define least-privilege role and scope the repo claim in trust policy.

Next steps
- Add concrete policy document limiting S3 PutObject to a specific bucket/prefix and SecurityHub import privileges.

4) Security Hub converter & ingestion

Concept
- Convert scanner output into Security Hub schema and import findings for centralized telemetry.

Solution
- `scripts/push-securityhub.py` converts Trivy JSON to Security Hub findings JSON.

Commands
```bash
python3 scripts/push-securityhub.py ./output/scan.json ./output/securityhub-findings.json
# then (after validating) import with:
aws securityhub batch-import-findings --findings file://./output/securityhub-findings.json
```

Issues
- JSON must match Security Hub schema; add validation tests before calling AWS CLI.

Next steps
- Add schema validation in Python and more complete mapping fields (ProductFields, Remediation, References).

5) Policies: Kyverno

Concept
- Enforce policies in CI or at runtime.

Solution
- Example CI step runs Kyverno CLI via Docker image to validate a `policies/` directory.

Commands
```bash
docker run --rm -v "${GITHUB_WORKSPACE}:/workspace" ghcr.io/kyverno/kyverno:latest kyverno test /workspace/policies
```

Issues
- Policies need to be authored to the environment (cluster or test harness).

Next steps
- Add example policies (e.g. require images with SBOM label, block images from public registries) and expected test JSON outputs for screenshots.

6) Terraform & IAM

Concept
- Show a minimal trust role for OIDC and discuss least-privilege policies.

Solution
- `terraform/iam-role.tf` template exists.

Commands
```bash
terraform init
terraform plan -var='aws_account_id=123456789012'
terraform apply -var='aws_account_id=123456789012' -auto-approve
```

Issues
- Template uses placeholders; replace `<owner>/<repo>` with actual values and create a policy document separately.

Next steps
- Create `iam-policy.tf` with a narrow policy for S3 and SecurityHub, attach to role.

7) Tests & automation

Concept
- Unit tests validate critical conversion logic before calling external services.

Solution
- `tests/test_push_securityhub.py` covers a happy path conversion.

Commands
```bash
pip install -r solutions/demo-sbom-lab/requirements.txt
pytest -q
```

Issues
- The environment used to run tests lacked pytest. Use venv in local/dev or a CI job that installs dev deps.

Next steps
- Expand tests for edge cases (no vulnerabilities, multiple results, missing fields) and add CI job step to run tests.

8) Local demo tooling

Concept
- Allow the full demo to run locally without AWS by using MinIO (S3-compatible) and local docker containers.

Solution (proposed)
- Add a `docker-compose.yml` with MinIO and a small helper container to run syft/trivy/convert and upload to MinIO.

Next steps
- I can implement this on request (option B from previous message).

End of work-area breakdown.
