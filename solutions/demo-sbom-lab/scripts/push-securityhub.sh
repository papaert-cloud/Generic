#!/usr/bin/env bash
set -euo pipefail

# push-securityhub.sh <scan-json>
SCAN=${1:-}

if [ -z "$SCAN" ]; then
  echo "Usage: $0 <scan-json>"
  exit 2
fi

# This script is a placeholder: converting a Trivy JSON result into Security Hub finding(s)
# and calling `aws securityhub batch-import-findings` requires constructing the expected JSON schema.
# See: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_BatchImportFindings.html

if ! command -v aws >/dev/null 2>&1; then
  echo "aws cli not found. Install AWS CLI v2"
  exit 2
fi

OUT_ENTRIES="./output/securityhub-findings.json"
mkdir -p "$(dirname "$OUT_ENTRIES")"

echo "Converting $SCAN -> Security Hub findings (placeholder)"
# Minimal mapping example: map each vulnerability to a simple finding object. Adjust fields before using.
jq -r '.Results[]? | .Vulnerabilities[]? | {Title: ("Vuln: " + (.VulnerabilityID // "unknown")), Description: .Description, Severity: .Severity, ProductArn: "arn:aws:securityhub:::product/aws/securityhub"} ' "$SCAN" | jq -s '{Findings: .}' > "$OUT_ENTRIES"

# The AWS CLI call would look like this (commented out; enable after validating the JSON shape):
# aws securityhub batch-import-findings --findings file://$OUT_ENTRIES

echo "Wrote placeholder Security Hub findings to $OUT_ENTRIES"

echo "Review $OUT_ENTRIES and run the aws cli call manually to import findings."
