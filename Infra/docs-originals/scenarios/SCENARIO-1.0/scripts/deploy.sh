#!/usr/bin/env bash
#set -euo pipefail

# deploy.sh — minimal wrapper to init/plan/apply the terraform in this folder
# Usage: ./deploy.sh plan|apply

COMMAND=${1:-plan}
TF_DIR="$(cd "$(dirname "$0")/.." && pwd)/terraform"

cd "$TF_DIR" || exit 2

case "$COMMAND" in
  plan)
    terraform init -input=false
    terraform validate
    terraform plan -out=tfplan -input=false
    ;;
  apply)
    terraform init -input=false
    terraform apply -input=false tfplan
    ;;
  *)
    echo "Usage: $0 plan|apply"
    exit 2
    ;;
esac
