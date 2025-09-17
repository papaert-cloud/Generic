🛡️ Developer's Open Notebook

✨ Motivation
Modern software supply chains need more than a passing nod to security. Vulnerabilities in third‑party dependencies, secrets committed to version control, and opaque build environments can all conspire to derail delivery. I built this portfolio to chronicle my journey towards a secure, automated pipeline that generates Software Bills of Materials (SBOMs), scans dependencies, signs container images, enforces policies at runtime and meets industry standards such as SLSA, SSDF and CIS. Rather than a polished recruiter‑facing repository, this is a developer’s open notebook: it captures why each workflow exists, how to run it locally, what to learn from it, and where you can extend it.

🧩 Project Overview
This project (AWS-SBOM-security-pipeline) demonstrates end‑to‑end DevSecOps practices in a reproducible environment:

Infrastructure‑as‑Code: Provision AWS resources (S3, IAM roles, KMS keys, ECR and optional EKS) using a mix of Terraform, Terragrunt and CloudFormation. The goal is to showcase both tools and explain how each can be used for modular, multi‑account deployments.

SBOM Generation and Scanning: Use Syft to generate CycloneDX and SPDX SBOMs from container images, and Grype and optional Snyk to scan them for vulnerabilities. Severity thresholds block the pipeline if Critical/High findings are present.

Secure Artifact Storage: Store SBOMs, scan reports and built images in a versioned S3 bucket encrypted with a KMS customer managed key. Artifacts are immutable and auditable to support SLSA/SSDF integrity requirements.

Cosign Image Signing: Use Sigstore cosign to sign container images and SBOM files. Verify signatures in Kubernetes admission controllers via Kyverno policies.

OIDC‑based CI/CD: Authenticate GitHub Actions to AWS using OpenID Connect. No long‑lived credentials live in the repository; GitHub issues a short‑lived token that the AWS Security Token Service exchanges for a role session. This satisfies least‑privilege guidance from SSDF and CIS.

Security Hub Integration: Convert vulnerability findings to the AWS Security Finding Format (ASFF) and ingest them into AWS Security Hub. This centralizes visibility and allows you to track remediation across accounts and regions.

Kubernetes Runtime Enforcement: Apply Kyverno policies in a local Kind cluster (or EKS) to enforce that workloads only run images that have valid signatures and acceptable vulnerability levels. You can extend these policies to include provenance checks, SBOM validation and additional gates.

Compliance Crosswalk: A living document in docs/compliance/ maps pipeline controls to relevant sections of the Supply‑chain Levels for Software Artifacts (SLSA), the Secure Software Development Framework (SSDF) and the CIS Benchmarks. Use this during interviews to explain how each control meets industry expectations.

🗂️ Repository Structure
text
.
├── infra/            # Terraform/Terragrunt modules and CloudFormation templates
├── pipelines/        # GitHub Actions workflows for build, scan, sign and deploy
├── scripts/          # Helper scripts (PowerShell/Bash) for bootstrapping and repair
├── k8s/              # Kubernetes manifests and Kyverno policies
├── app/              # Sample application code used for demonstration
├── docs/             # Deep‑dive explanations, compliance mapping and personal notes
└── README.md         # This file – explains how and why
Tip:
Each directory contains its own README or inline comments to explain what the files do and how they interrelate. Feel free to explore.

🚀 Getting Started
Prerequisites
Environment: A Linux or WSL (Windows Subsystem for Linux) shell with Docker/Podman, Git and Node.js installed.

AWS Account: Access to an AWS account with permissions to create S3 buckets, IAM roles and (optionally) EKS clusters. Choose a default region (e.g., us-east-1).

GitHub: A repository (public or private) where you can push this project. You will need admin permissions to configure OpenID Connect.

Tools: Install the following CLI tools locally or use the provided bootstrap script:
Terraform and Terragrunt – infrastructure provisioning.
AWS CLI – interact with AWS services.
Syft and Grype – SBOM and vulnerability scanning.
Cosign – sign and verify images/artifacts.
Kyverno CLI – test policies locally.
Kind (optional) – run a local Kubernetes cluster to test runtime policies.

Bootstrap
bash
git clone (https://github.com/papaert-cloud/Generic.git)
cd docs-reorg

pwsh scripts/bootstrap/New-Lab.ps1 -Explain
This script uses config files under config/ to determine paths and defaults. It is idempotent and can be run multiple times. The -Explain flag prints teaching notes inline so you understand each step.

Inventory
bash
pwsh scripts/inventory/Inventory-Tools.ps1 -Explain
Inventory your tools using the provided script. It will detect installed CLIs, VS Code extensions and WSL distributions, then recommend installations for anything missing.

Provision Infrastructure
Navigate to infra/ and follow instructions in submodule README.

bash
cd infra/base
terraform init
terraform apply -var "aws_region=us-east-1" -auto-approve
Configure GitHub OIDC by creating an IAM role with a trust policy that allows your GitHub repository’s OIDC provider to assume it. The infra/github-oidc module provides an example. Update the trust policy with your repository’s ARN and push it using Terraform.

Commit and Push
Commit and push your changes to GitHub. Once in place, GitHub Actions workflows in the pipelines/ folder will automatically build, scan, sign and deploy your sample application on each push.

🏗️ Running the Pipeline
When you push code to your repository, GitHub Actions will execute the workflows defined in pipelines/. The major stages are:

Build – compile the sample application and build a Docker image.

SBOM – run syft to generate SBOMs in CycloneDX and SPDX formats.

Scan – run grype and (optionally) snyk to detect vulnerabilities. Fail the build if severity gates are exceeded.

Sign – use cosign to sign the image and SBOMs. Push the signature to the OCI registry.

Publish – upload SBOMs, reports and (optionally) the image to your S3 bucket.

Ingest – convert vulnerability findings into ASFF and call the BatchImportFindings API for Security Hub.

Deploy – apply Kubernetes manifests and Kyverno policies to your cluster. Only signed images with acceptable vulnerabilities will run.

Each step is annotated with comments and includes environment variables for customization. See the workflow YAML files for details.

📚 Learning Roadmap
This notebook is meant for continual learning. Start small by running the bootstrap and inventory scripts, then move on to provisioning the minimal infrastructure. Once comfortable, explore SBOM generation and scanning locally. As you become confident with the tools, enable cosign signing and Security Hub ingestion. Finally, test Kyverno policies in Kind or EKS. Feel free to branch off and add new scenarios (e.g., adding SBOM validation to serverless applications or integrating source composition analysis). Use the Cue Learn command in your interactive prompts to ask for deep‑dive teaching sessions on any of these components.

⚡ Extending the Portfolio
This project is intentionally modular. Here are a few ideas for extension:

Add additional scanners such as Trivy for container image scanning or Semgrep for SAST.

Support multiple clouds by adding Terraform modules for Azure or GCP equivalents of S3, KMS and OIDC roles.

Integrate policy as code frameworks like Open Policy Agent (OPA) or Datree alongside Kyverno.

Automate remediation by wiring Security Hub findings into chat or ticketing systems.

Expand compliance mapping to frameworks like ISO/IEC 27001 or NIST 800‑53.

Please open an issue or pull request if you would like to contribute.

❓ Getting Help
If you encounter problems or want to learn more about a particular component, you can:

Read the documentation in the docs/ directory or run scripts with the -Explain flag to print inline teaching notes.

Use the Cue Technical command in your interactive session to request a step‑by‑step guide on any topic.

Search official vendor documentation (Terraform, AWS, Kyverno, Sigstore) for deeper reference.

📜 License
This project is licensed under the MIT License. Feel free to use and adapt it for your own learning and professional development.
