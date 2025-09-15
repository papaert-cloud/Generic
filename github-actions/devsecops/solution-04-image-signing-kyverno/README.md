# Solution 04 — Image Signing & Kyverno Enforcement (DevSecOps)

Purpose: Demonstrate signing images with cosign and enforcing image policies in EKS with Kyverno.

Key features:
- Use cosign to sign images; prefer KMS-backed keys (KMS URIs)
- CI will sign images after successful scanning
- Kyverno policy example to reject images without valid signature or missing sbom-validated annotation
- Demo manifests to deploy Kyverno policies to test cluster

Files included:
- `.github/workflows/sign-and-push.yml` (example signing workflow)
- `kyverno/policies/` — example deny policy
- `scripts/sign_image.sh` — cosign sign helper

Notes: For cosign keys, prefer KMS or Keyless mode with OIDC; do not store raw private keys in GitHub secrets.
