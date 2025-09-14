# Image Rebase & Rebuild

Purpose: Regularly rebuild images on updated base images to inherit security patches (distroless/base image updates).

Process:
- Detect new base image digest -> rebuild dependent images -> run SCA + sign -> push and open PRs

Notes:
- Keep matrix builds manageable; target high-impact base image updates first.
