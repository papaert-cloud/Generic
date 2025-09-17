#!/usr/bin/env bash
set -euo pipefail

# upload-sbom.sh <file> <s3://bucket/prefix/>
FILE=${1:-}
S3URI=${2:-}

if [ -z "$FILE" ] || [ -z "$S3URI" ]; then
  echo "Usage: $0 <file> <s3://bucket/prefix/>"
  exit 2
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "aws cli not found. Install AWS CLI v2 or use the docker-based upload (see local demo)."
  exit 2
fi

# Support S3-compatible endpoints (MinIO) via S3_ENDPOINT env var, e.g. http://localhost:9000
S3_ENDPOINT_ARG=""
if [ -n "${S3_ENDPOINT:-}" ]; then
  S3_ENDPOINT_ARG="--endpoint-url ${S3_ENDPOINT}"
  echo "Using S3 endpoint: ${S3_ENDPOINT}"
fi

echo "Uploading $FILE -> $S3URI"
eval aws s3 cp "$FILE" "$S3URI" $S3_ENDPOINT_ARG

echo "Upload complete"
