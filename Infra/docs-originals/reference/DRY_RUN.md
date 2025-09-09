DRY_RUN mode — how it works and how to use

Overview

DRY_RUN mode allows scripts to simulate network actions (like `git push`) without contacting remotes. This is useful for CI and local testing where you don't have credentials or do not want to affect remote state.

How it was implemented

- `commit-and-push.sh` checks the `DRY_RUN` environment variable. If `DRY_RUN=1` and `AUTO_PUSH=1`, the script prints the `git push --dry-run` command instead of executing it.
- The post-commit hook in `docs/hooks/post-commit` also respects `DRY_RUN=1`.

How to use

- Local dry-run commit (no remote push):

```bash
DRY_RUN=1 ./scripts/commit-and-push.sh -m "chore: test"
```

- CI local testing (example in Github Actions): set the environment variable `DRY_RUN=1` in the workflow for plan-only jobs.

Notes and caveats

- `git push --dry-run` behaves slightly differently across git versions and may still attempt to contact remotes for negotiation; it's safer to run CI in a network-isolated environment when absolute non-network guarantees are required.
- For Terraform, using `terraform plan` and `terraform show -json` is a non-destructive way to analyze changes without apply.
