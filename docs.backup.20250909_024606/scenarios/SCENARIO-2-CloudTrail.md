
# Scenario 2: Design centralized CloudTrail with complete coverage and fix gaps

STAR summary

- S: Team saw events in a member account that didn’t appear in the central account’s Event History.
- T: Ensure org-wide CloudTrail with Organization trail, all regions, management + data events, and S3/CloudWatch destinations with KMS.
- A: Enabled Org CloudTrail, added data events (S3, Lambda), verified bucket policy/KMS key policy allow CloudTrail + central account read. Built a guardrail Lambda to fail fast when a new account lacks trail attachment. Troubleshot the missing event via region mismatch and “Event History” vs. “S3 log file” understanding; validated retention and S3 prefixes.
- R: Closed gaps, documented runbook + CloudWatch alarms for delivery failures.

## Refresher

- Org trail (all regions) > data events > KMS & bucket policy > monitoring + alarms > difference between Event History (90 days, partial) vs S3 logs (authoritative).

Analogy: the 911 dispatcher’s live screen isn’t the official logbook—the S3 logbook is.

## Playbook / Runbook notes

1. Ensure an Organization trail is created in the Management (Org) account with "Apply to all accounts" enabled and logging in all regions.
2. Configure the trail to capture management events and data events (S3, Lambda, and any other important data-plane APIs).
3. Configure log delivery to an encrypted S3 bucket in the central logging account. Use KMS key policy that allows CloudTrail to encrypt and the security/analysis account to decrypt.
4. Ensure the S3 bucket policy explicitly allows PutObject from the CloudTrail service principal and allows the central analysis account read access to the bucket prefixes where logs are delivered.
5. Add CloudWatch metric filters and alarms for: delivery failures, PutObjectDenied errors, and unmatched account deliveries.
6. Optional: Add an EventBridge rule in member accounts to forward specific management events in near-real-time to security tooling.

## Troubleshooting common gaps

- Region mismatch: CloudTrail delivers to S3 per-region; verify the trail is multi-region.
- Event History vs S3 logs: Event History is a convenience view for ~90 days and may be incomplete. Rely on S3 logs for authoritative auditing.
- Missing data events: Ensure data events (S3 object-level, Lambda Invoke) are explicitly enabled on the Organization trail.
- Permissions: KMS key and bucket policies must allow CloudTrail to write and the central account to read.

## Question to ask stakeholders

Do you rely on central EventBridge to fan out detections from CloudTrail to multiple tenants?
