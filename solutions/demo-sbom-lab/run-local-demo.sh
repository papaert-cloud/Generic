#!/usr/bin/env bash
set -euo pipefail

# run-local-demo.sh
# Brings up MinIO (docker-compose), generates SBOM and scan using dockerized tools,
# converts findings, and uploads artifacts to MinIO via aws-cli docker image.

# Requirements: docker, docker-compose, python3 (for converter)

COMPOSE_DIR="$(dirname "$0")/.."
ROOT="$(cd "$COMPOSE_DIR" && pwd)"
cd "$ROOT"

# Load defaults from .env.example if .env not present
if [ -f .env ]; then
  set -o allexport; source .env; set +o allexport
else
  echo "Warning: .env not found; using .env.example defaults"
  set -o allexport; source ./.env.example; set +o allexport
fi

echo "Starting MinIO (docker-compose)"
docker compose up -d minio

echo "Waiting for MinIO to become healthy..."
# simple wait loop
for i in {1..20}; do
  if curl -sS "http://localhost:9000/minio/health/live" >/dev/null 2>&1; then
    echo "MinIO healthy"
    break
  fi
  echo "waiting..."
  sleep 2
done

mkdir -p output

# Generate SBOM using syft docker image
echo "Generating SBOM with syft (docker)"
docker run --rm -v "$ROOT:/work" anchore/syft:latest syft dir:/work -o json > output/sbom.json

echo "Scanning with trivy (docker)"
docker run --rm -v "$ROOT:/work" aquasec/trivy:latest trivy filesystem --format json -o /work/output/scan.json /work || true

# Convert scan to Security Hub findings JSON (local converter)
python3 scripts/push-securityhub.py output/scan.json output/securityhub-findings.json

# Create bucket in MinIO using aws-cli docker image, then upload
echo "Creating bucket in MinIO: $MINIO_BUCKET"
docker run --network host --rm -e AWS_ACCESS_KEY_ID=${MINIO_ROOT_USER} -e AWS_SECRET_ACCESS_KEY=${MINIO_ROOT_PASSWORD} amazon/aws-cli s3 mb "s3://${MINIO_BUCKET}" --endpoint-url http://localhost:9000 || true

echo "Uploading artifacts to MinIO"
docker run --network host --rm -e AWS_ACCESS_KEY_ID=${MINIO_ROOT_USER} -e AWS_SECRET_ACCESS_KEY=${MINIO_ROOT_PASSWORD} -v "$ROOT:/work" amazon/aws-cli s3 cp /work/output/sbom.json "s3://${MINIO_BUCKET}/${MINIO_PREFIX}/sbom.json" --endpoint-url http://localhost:9000

echo "Uploading scan and findings"
docker run --network host --rm -e AWS_ACCESS_KEY_ID=${MINIO_ROOT_USER} -e AWS_SECRET_ACCESS_KEY=${MINIO_ROOT_PASSWORD} -v "$ROOT:/work" amazon/aws-cli s3 cp /work/output/scan.json "s3://${MINIO_BUCKET}/${MINIO_PREFIX}/scan.json" --endpoint-url http://localhost:9000

echo "Local demo complete. Artifacts in MinIO at http://localhost:9001 (console)."
echo "Bucket: ${MINIO_BUCKET}, Prefix: ${MINIO_PREFIX}"
