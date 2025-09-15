#!/usr/bin/env bash
# deploy-stackset.sh - create or update a CloudFormation StackSet and deploy to OU
# Usage: ./deploy-stackset.sh <stackset-name> <template-file> <ou-id>

set -euo pipefail

STACKSET_NAME=${1:-enable-s3-bpa-stackset}
TEMPLATE_FILE=${2:-enable-bpa-stackset.yaml}
OU_ID=${3:-ou-im88-1fmr1yt9}

if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Template file $TEMPLATE_FILE not found" >&2
  exit 1
fi

# Create a new StackSet or update existing
aws cloudformation create-stack-set --stack-set-name "$STACKSET_NAME" --template-body file://$TEMPLATE_FILE --capabilities CAPABILITY_NAMED_IAM || true

# Create stack instances for the OU
aws cloudformation create-stack-instances --stack-set-name "$STACKSET_NAME" --deployment-targets OrganizationalUnitIds=$OU_ID --regions us-east-1 || true

echo "Requested StackSet deployment to OU $OU_ID. Monitor in the CloudFormation console."
