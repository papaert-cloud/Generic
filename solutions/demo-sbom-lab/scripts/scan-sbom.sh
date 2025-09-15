#!/usr/bin/env bash
set -euo pipefail

# scan-sbom.sh <sbom.json> <out-scan.json>
SBOM=${1:-}
OUT=${2:-./scan.json}

if [ -z "$SBOM" ]; then
  echo "Usage: $0 <sbom.json> <out-scan.json>"
  exit 2
fi

if ! command -v trivy >/dev/null 2>&1; then
  echo "trivy not found. Install from https://aquasecurity.github.io/trivy/"
  exit 2
fi

mkdir -p "$(dirname "$OUT")"

# example: trivy supports scanning SBOMs or images; here we assume we scan the image referenced in the SBOM (best-effort)
IMAGE=$(jq -r '.artifact.metadata.image | select(.!=null) | .name' "$SBOM" 2>/dev/null || true)
if [ -n "$IMAGE" ]; then
  echo "Found image in SBOM: $IMAGE — scanning image"
  trivy image --format json -o "$OUT" "$IMAGE"
else
  echo "Image not found in SBOM; running trivy filesystem scan as fallback"
  trivy filesystem --format json -o "$OUT" .
fi

echo "Scan saved to $OUT"
