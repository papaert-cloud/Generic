SCENARIO 1.1 — Enforce no public S3 access across all AWS accounts

This folder contains an opinionated, production-ready implementation guide, IaC templates, CI/CD pipeline examples, and scripts to enforce "no public S3" across an AWS Organization.

High-level summary
- Put S3 Block Public Access (BPA) at account level (prevents ACLs and policies from enabling public access)
- Enforce deny rules via an Organization Service Control Policy (SCP) to block common public ACLs
- Use AWS Config Organization Managed Rules to detect public bucket policies and ACLs
- Wire EventBridge -> SNS (or Lambda) to alert / auto-remediate
- Gate IaC changes in CI (Github Actions) with Checkov, cfn-lint, and terraform-plan-check

Files in this package (local-only under `docs/scenarios/SCENARIO-1.1`):
- `SCENARIO-1.1.md` — this file (explanation, design, tests, and references)
- `README.md` — quick start for operators and engineers
- `terraform/main.tf` — Terraform resources for org-SCP, Config org rules, EventBridge and SNS
- `terraform/variables.tf` — Terraform variables
- `terraform/outputs.tf` — Terraform outputs
- `scripts/deploy.sh` — helper to bootstrap and apply per-account where necessary
- `github-actions/ci-s3-security.yml` — Github Actions workflow template for pipeline gating

Design decisions and rationale
- Use defense in depth. BPA prevents many common cases. SCP prevents ACL-based changes. Config provides detection of policy-based public exposure which SCP can't reliably inspect. EventBridge/SNS provide alerting and can trigger automatic remediation.
- Avoid destructive auto-remediations by default; provide optional Lambda-runbooks for automated containment when required by policy.
- Use org-level Config rules so every account is continuously evaluated and compliance data is aggregated.

Step-by-step approach (operator-ready)
1. Pre-reqs: you must run org-level Terraform from the management account with Organization:FullAccess. Ensure your AWS CLI profile is configured for the management account.
2. Apply the Organization SCP (Terraform) — this denies requests which set public ACLs. It is conservative and prevents new public ACLs from being created.
3. Enable `aws_s3_account_public_access_block` in each target account. This requires running Terraform from each account or using an automation (SSM Run Command / CloudFormation StackSet / Terraform with multiple providers).
4. Deploy AWS Config Organization Managed Rules for `s3-bucket-public-read-prohibited` and `s3-bucket-public-write-prohibited`.
5. Create an EventBridge rule that listens for Config rule compliance changes and sends notifications to an SNS topic and optionally triggers a Lambda that remediates or quarantines the bucket.
6. Add a CI gate (Github Actions) which runs Checkov and terraform plan checks and fails PRs that introduce public ACLs, public policy statements, or disable BPA.

Permissions required (principle of least privilege)
- Management account (to manage org-wide control):
  - organizations:CreatePolicy, organizations:AttachPolicy, organizations:ListRoots, organizations:DescribeOrganization
  - config:PutConfigurationAggregator, config:PutOrganizationConfigRule, config:PutDeliveryChannel
  - events:PutRule, events:PutTargets
  - sns:CreateTopic, sns:Publish
- Per-account (to enable BPA and other account-level resources):
  - s3:PutAccountPublicAccessBlock
  - config:PutConfigurationRecorder, config:PutDeliveryChannel
  - iam:PassRole (if you add remediation lambdas)

Definition of Done (DoD)
- Org-level SCP deployed and attached to Root (or target OUs).
- S3 Block Public Access enabled account-wide for each member account.
- AWS Config organization-managed rules deployed and reporting compliant/non-compliant status in the aggregator.
- EventBridge rule and SNS topic exist and successfully receive Config compliance change events.
- CI pipeline rejects IaC that would create public ACLs or disable BPA.

Validation tests
- Terraform plan shows only intended changes.
- Create test bucket (in a sandbox account) and attempt to set public ACLs — expected: blocked by BPA or SCP.
- Add a bucket policy granting Principal:"*" — expected: Config flags non-compliant and EventBridge triggers an alert.

Possible expansions / alternatives
- Auto-remediation Lambda that removes public statements from bucket policies or moves objects to quarantine S3.
- Use AWS Firewall Manager for S3 (if available for your accounts/sku) to centralize protection.
- Implement GuardDuty + Security Hub correlation for public exposure alerts.

References and further reading
- AWS S3 Block Public Access: https://docs.aws.amazon.com/AmazonS3/latest/userguide/block-public-access.html
- AWS Config managed rules (S3): https://docs.aws.amazon.com/config/latest/developerguide/s3-policy-checker.html
- AWS Organizations SCP overview: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html
- Checkov: https://www.checkov.io/
- GitHub Actions: https://docs.github.com/en/actions

If you want, I will now deploy the Terraform templates in `terraform/` (dry-run first), or create a CI pipeline that runs these checks on PRs. Tell me which to run first (deploy IaC from management account, or create CI gating in the repo).
