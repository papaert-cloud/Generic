Local demo (MinIO) — quickstart

This folder contains a quick local demo setup so you can run the SBOM -> scan -> upload flow without AWS.

Prerequisites
- Docker & Docker Compose
- Python 3 installed locally (for the converter script)

Steps
1. Copy `.env.example` to `.env` and optionally change credentials and bucket name.
2. Start the local demo:

   chmod +x run-local-demo.sh
   ./run-local-demo.sh

3. Open MinIO Console: http://localhost:9001
   Login: `demo` / `demo12345` (or your `.env` values)

What the script does
- Starts a MinIO container
- Runs Syft (docker) to generate `output/sbom.json`
- Runs Trivy (docker) to produce `output/scan.json`
- Runs `push-securityhub.py` to produce `output/securityhub-findings.json`
- Uploads artifacts to MinIO using `amazon/aws-cli` docker image

Notes
- This demo runs using dockerized tools so you don't need to install syft/trivy/aws locally.
- You can modify `run-local-demo.sh` to change image names or bind mounts.
