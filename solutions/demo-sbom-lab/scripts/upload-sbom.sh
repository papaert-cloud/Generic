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
  echo "aws cli not found. Install AWS CLI v2"
  exit 2
fi

echo "Uploading $FILE -> $S3URI"
aws s3 cp "$FILE" "$S3URI"

echo "Upload complete"
