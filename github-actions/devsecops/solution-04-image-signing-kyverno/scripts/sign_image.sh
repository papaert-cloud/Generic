#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"
KMS_KEY_URI="$2"

# Sign with cosign using KMS key
cosign sign --key "${KMS_KEY_URI}" "${IMAGE}"

echo "Signed ${IMAGE} with ${KMS_KEY_URI}"
