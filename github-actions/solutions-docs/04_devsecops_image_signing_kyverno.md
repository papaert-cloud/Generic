# DevSecOps Solution 04 — Image Signing & Kyverno Enforcement (High-impact)

Situation
Ensure only approved, scanned, and signed images run in Kubernetes clusters.

Goal
Sign images in CI using cosign (KMS-backed keys), store SBOMs, and enforce admission controls with Kyverno to reject unsigned/unaltered images.

Pipeline (code-to-prod)
1. CI builds image and runs SCA; if clear, cosign signs image using KMS key.
2. Push signed image to ECR and record SBOM in S3.
3. Kyverno cluster policy verifies signature presence and sbom-validated annotation; denies pods that fail policy.

Implementation notes
- Use cosign with KMS: `cosign sign --key kms://arn:aws:kms:us-east-1:005965605891:key/KEYID`.
- Kyverno can call an external webhook or use image policy checks; for signature verify you may use an admission controller that runs `cosign verify` logic.

Evidence & Audit
- Signed image metadata (cosign signature) stored in registry
- SBOM stored in S3 with run-id folder
- Kyverno policy audit logs kept via cluster logging to CloudWatch or ELK

Commands (WSL)
```bash
# sign image
cosign sign --key kms://arn:aws:kms:us-east-1:005965605891:key/EXAMPLE myregistry/myapp:tag

# verify
cosign verify --key kms://arn:aws:kms:us-east-1:005965605891:key/EXAMPLE myregistry/myapp:tag
```

Interview talking points
- Keyless cosign vs KMS-backed: KMS offers centralized key control and audit in AWS; keyless avoids key storage but relies on OIDC and transparency logs.
