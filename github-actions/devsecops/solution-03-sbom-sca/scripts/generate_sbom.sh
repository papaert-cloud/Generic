#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"
OUTDIR="artifacts"
mkdir -p "$OUTDIR"

# generate cyclonedx SBOM
syft "$IMAGE" -o cyclonedx-json="$OUTDIR/sbom.cyclonedx.json"

# also generate SPDX if desired
# syft "$IMAGE" -o spdx-json="$OUTDIR/sbom.spdx.json"

echo "SBOMs written to $OUTDIR"
