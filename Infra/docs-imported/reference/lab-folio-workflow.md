# lab-folio workflow helpers

This document explains the helper scripts and git hook that enforce a policy where all commits are pushed to the `lab-folio` branch.

Files added:
- `scripts/commit-and-push.sh` — safe commit helper; enforces branch and can auto-push.
- `scripts/push-to-lab-folio.sh` — explicit push helper.
- `.git/hooks/post-commit` — local git hook (not tracked) that either pushes automatically or reminds you to push.

Quick usage:

- Commit and optionally auto-push (safer):

```bash
# Interactive: ask for confirmation when needed
AUTO_PUSH=0 ./scripts/commit-and-push.sh -m "Add feature"

# Auto push after commit
AUTO_PUSH=1 ./scripts/commit-and-push.sh -m "WIP: changes"
```

- Manual push:

```bash
./scripts/push-to-lab-folio.sh
# or
git push origin lab-folio
```

Notes & safety:

- Hooks in `.git/hooks` are local and not shared; make them executable with `chmod +x .git/hooks/post-commit`.

- The scripts default to refusing commits when not on `lab-folio`. Use `FORCE_ALLOW=1` or change branch manually if needed.

- AUTO_PUSH is enabled by default in this environment. That means commits made with `./scripts/commit-and-push.sh` will automatically push to `origin/lab-folio` unless you set `AUTO_PUSH=0`.

- These scripts intentionally avoid hardcoding secrets and use environment variables for behavior toggles.

Next steps:
- If you want automatic enforcement across machines, consider adding a CI gate that rejects PRs/merges not targeting `lab-folio`.
