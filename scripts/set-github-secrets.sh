#!/usr/bin/env bash
# Set repository secrets using gh (GitHub CLI)
# Usage:
#  - Interactive: ./scripts/set-github-secrets.sh
#  - Non-interactive: export GH_REPO='owner/repo' and export secrets as env vars, then run.

set -euo pipefail

REPO_DEFAULT="papaert-cloud/Generic"
GH_REPO=${GH_REPO:-$REPO_DEFAULT}

# List of secrets we commonly need for workflows.
# You can extend this list as needed.
SECRETS=(
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_SESSION_TOKEN
  AWS_REGION
  AWS_ACCOUNT_ID
  DOCKERHUB_USERNAME
  DOCKERHUB_TOKEN
  SONAR_TOKEN
  COSIGN_KMS_KEY_ARN
  ECR_PUSH_ROLE_ARN
  TF_VAR_some_sensitive
)

# Helper: set a single secret using gh
set_secret() {
  local name="$1"
  local val="${!name:-}"
  if [ -z "$val" ]; then
    read -r -p "Enter value for $name (leave empty to skip): " input
    val="$input"
  fi
  if [ -z "$val" ]; then
    echo "Skipping $name (no value supplied)"
    return
  fi
  echo "Setting secret $name for repo $GH_REPO"
  gh secret set "$name" --body "$val" --repo "$GH_REPO"
}

# Ensure gh exists and is authenticated
if ! command -v gh >/dev/null 2>&1; then
  echo "gh (GitHub CLI) not found. Install it and login with 'gh auth login' before running this script." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "gh not authenticated. Run 'gh auth login' and try again." >&2
  exit 1
fi

echo "Using repository: $GH_REPO"

for s in "${SECRETS[@]}"; do
  set_secret "$s"
done

echo "Done. Verify secrets in https://github.com/$GH_REPO/settings/secrets/actions"
