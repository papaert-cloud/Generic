# 06 - Testing, Verification & Gates

## Automated tests
- Unit tests for application code
- SAST: bandit, gosec, ESLint, spotbugs depending on language
- SBOM + SCA scans
- Integration tests: terraform apply to ephemeral account or test VPC, run smoke tests

## Gates
- Fail PR on critical/high CVEs in SBOM/SCA
- Require passing `tflint`/`checkov` for IaC
- Require code owner approvals for infra changes

## Verification jobs
- Post-deploy DAST (OWASP ZAP full scan) scheduled nightly for staging
- Periodic SBOM re-scan (nightly) to catch new CVEs

## Smoke tests example
# Use kubectl port-forward or test endpoints directly
# curl -f https://staging.example.com/health || exit 1

## Reporting
- Upload all reports to S3 and publish summary to Slack or MS Teams via webhook
