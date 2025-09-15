#!/usr/bin/env bash
set -euo pipefail

SBOM="$1"
OUTDIR="artifacts"
mkdir -p "$OUTDIR"

grype "sbom:$SBOM" -o json > "$OUTDIR/grype.json"

echo "Grype scan saved to $OUTDIR/grype.json"
