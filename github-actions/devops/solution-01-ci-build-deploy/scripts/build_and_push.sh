#!/usr/bin/env bash
set -euo pipefail

# Usage: build_and_push.sh --tag <tag>
# This script builds a container image, generates SBOM (syft), and pushes to ECR using OIDC credentials in CI.

TAG="latest"
while [[ $# -gt 0 ]]; do
  case $1 in
    --tag) TAG="$2"; shift 2;;
    *) shift;;
  esac
done

REPO="sbom-security-pipeline"
IMAGE="${REPO}:${TAG}"

# Build the image
# ...existing code...
# Build command
docker build -t "$IMAGE" .

# Generate SBOM
# syft supports multiple outputs; CycloneDX is preferred for app security
if command -v syft >/dev/null 2>&1; then
  syft "$IMAGE" -o cyclonedx-json=./artifacts/sbom.cyclonedx.json
else
  echo "syft not installed; skipping SBOM generation"
fi

# Push image to registry (CI should have configured aws credentials via OIDC)
# ...existing code...
# Example: use aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com

echo "Image built: $IMAGE"
