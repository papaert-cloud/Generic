This repository uses several GitHub Actions that depend on repository secrets (for AWS, DockerHub, Sonar, cosign KMS, etc.).

You can add secrets in two ways:

1) Use the GitHub web UI (Settings → Secrets → Actions) — screenshot reference provided in repo attachments.

2) Use the GitHub CLI (recommended for automation):

   - Install and authenticate `gh` (https://cli.github.com/)
   - Run the included script:

     ```bash
     chmod +x scripts/set-github-secrets.sh
     ./scripts/set-github-secrets.sh
     ```

   - You can pre-export environment variables for non-interactive runs, e.g.:

     ```bash
     export GH_REPO="papaert-cloud/Generic"
     export AWS_ACCESS_KEY_ID="AKIA..."
     export AWS_SECRET_ACCESS_KEY="..."
     ./scripts/set-github-secrets.sh
     ```

Secrets the script manages by default:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN (optional)
- AWS_REGION
- AWS_ACCOUNT_ID
- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN
- SONAR_TOKEN
- COSIGN_KMS_KEY_ARN
- ECR_PUSH_ROLE_ARN
- TF_VAR_some_sensitive (example)

Security note: Do not commit secret values into the repo. Use the CLI or the web UI to populate them. The screenshot attached in the repo shows the GitHub UI where you can add secrets manually.
