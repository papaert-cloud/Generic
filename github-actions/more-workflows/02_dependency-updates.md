# Dependency Updates (scheduled)

Purpose: Automate dependency updates to reduce exposure to known vulnerable versions.

Approach:
- Weekly scheduled job to run update commands or trigger Dependabot
- Create PRs with updated versions and run full CI including SBOM/SCA

Pitfalls:
- Update churn — prefer batching or grouping semver-minor updates
- Always test rebuilt images in staging before promotion
