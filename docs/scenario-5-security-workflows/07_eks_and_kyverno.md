# 07 - EKS Runtime Enforcement (Kyverno)

## Goals
- Prevent deployment of unsigned or non-compliant images
- Enforce labels/annotations (e.g., sbom-validated=true)
- Mutate resources to add default security context

## Example Kyverno validation policy (conceptual)
# - deny images with no signature annotation
# - require imagePullPolicy: IfNotPresent only for dev

## Process
1. After CI signs images, add SBOM and signature metadata to image manifest or image tag
2. Kyverno verifies signature (you can use an admission webhook to call cosign verify) or rely on image registry policies
3. If image fails policy, admission denies create

## Notes
- For production, couple Kyverno with runtime tools like Falco for detection
- Keep policies under version control and test them in staging cluster
