#!/usr/bin/env bash
set -euo pipefail

# generate-sbom.sh <image-or-dir> <out.json>
IMAGE_OR_DIR=${1:-}
OUT=${2:-./sbom.json}

if [ -z "$IMAGE_OR_DIR" ]; then
  echo "Usage: $0 <image-or-dir> <out.json>"
  exit 2
fi

if ! command -v syft >/dev/null 2>&1; then
  echo "syft not found. Install from https://github.com/anchore/syft"
  exit 2
fi

mkdir -p "$(dirname "$OUT")"

echo "Generating SBOM for $IMAGE_OR_DIR -> $OUT"
syft "$IMAGE_OR_DIR" -o json > "$OUT"

echo "SBOM written to $OUT"
