SCENARIO 1.1 — Implementation dump

Goal

Guarantee no publicly accessible S3 buckets across all AWS accounts in an Organization. Provide detection, alerting, prevention, and CI gates to catch accidental or malicious changes.

Executive summary

We implement defense-in-depth:

1. Prevent: S3 Block Public Access (BPA) at account level + Organization SCP that denies PutBucketAcl/PutObjectAcl with public ACLs.
2. Detect: AWS Config organization managed rules `s3-bucket-public-read-prohibited` and `s3-bucket-public-write-prohibited` to catch policy changes that grant public access.
3. Alert: EventBridge rule listens to Config compliance changes -> SNS topic (email and optional Lambda).
4. Gate: GitHub Actions pipeline runs terraform plan + Checkov and greps the plan for public ACL strings to fail PRs.

Why this combination?

- BPA handles most cases (ACLs and policies at the account level).
- SCP enforces at the organization level to stop API calls that would change ACLs even from privileged principals.
- Config provides continuous monitoring and an authoritative record of compliance state.
- EventBridge/SNS allow for near-real-time alerts and possible auto-remediation hooks.
- CI gates reduce human error by preventing IaC that introduces public access from being merged.

Pre-requisites and permissions

- AWS Organization with management account credentials and an IAM user/role having:
  - organizations:AttachPolicy, CreatePolicy, DescribeOrganization
  - config:PutConfigurationAggregator, PutOrganizationConfigRule
  - events:PutRule, PutTargets
  - sns:CreateTopic, Subscribe
- Terraform v1.5+ and the AWS provider (~> 5.0).
- GitHub repo for CI, with secrets for AWS credentials if CI will run plan/apply.

Files created (local-only)

- `terraform/` — Terraform resources for SCP, Config org rules, EventBridge rule, SNS topic
- `scripts/deploy.sh` — helper to run terraform
- `github-actions/ci-s3-security.yml` — GitHub Actions workflow template to gate PRs

Detailed steps (operator)

1. Review the Terraform in `docs/scenarios/SCENARIO-1.1/terraform` and set variables in a `terraform.tfvars` file.

2. From the Organization management account (or with a role that can assume), run:

```bash
export AWS_PROFILE=org-management
cd docs/scenarios/SCENARIO-1.1/terraform
./../scripts/deploy.sh plan
# review plan
./../scripts/deploy.sh apply
```

3. For each member account, ensure S3 Block Public Access enabled. Options:

- Run a per-account Terraform that sets `aws_s3_account_public_access_block`.
- Use Terraform with multiple providers and assume-role to apply across accounts.
- Use CloudFormation StackSets or SSM Run Command to execute updates across accounts.

Tests and validation

- Manual: Attempt to create public ACL on a test bucket in a member account. Expected: request denied or flagged by Config.
- Config console: See compliance reports in the aggregator.
- CI: Create a PR that adds public ACL resource in Terraform - GitHub Actions should fail.

Edge cases and pitfalls

- SCPs are powerful: misconfigured denies may block legitimate automation. Use a targeted policy and test in a sandbox OU.
- Config aggregator requires a role ARN: ensure the aggregator role has proper permissions and that trust relationships are set.
- EventBridge -> SNS deliverability: email subscriptions require confirmation from the recipient.
- Auto-remediation: avoid destructive automatic deletions unless you're prepared for rollback and have monitoring.

Alternatives and expansions

- Auto-remediate with Lambda: build a Lambda that on Config non-compliant event will remove Public statements from bucket policies and/or set bucket ACL to private. Add IAM role for the Lambda.
- Use AWS Firewall Manager for centralized management of S3 access and policies (enterprise only).
- For real-time enforcement of S3 object-level ACLs, consider object-level scanning for public-read objects and lifecycle rules to quarantine such objects.

References

- AWS S3 Block Public Access: https://docs.aws.amazon.com/AmazonS3/latest/userguide/block-public-access.html
- AWS Config S3 managed rules: https://docs.aws.amazon.com/config/latest/developerguide/s3-policy-checker.html
- AWS Organizations SCP: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html
- Checkov: https://www.checkov.io/
- GitHub Actions docs: https://docs.github.com/en/actions


*** END OF DUMP
