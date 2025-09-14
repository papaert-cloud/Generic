Setup hooks — how to install local git hooks from `docs/hooks`

1. Review the hooks in `docs/hooks/` (they are local copies of the hook scripts). Edit as needed.
2. Run the setup script to copy them into the repo's `.git/hooks`:

```bash
./scripts/setup-hooks.sh
```

3. Confirm hooks installed and executable:

```bash
ls -l .git/hooks
```

Notes:
- Hooks in `.git/hooks` are local only. If you want to share hooks with the team, consider adding a repo-level setup script or use a git template.
- The `setup-hooks.sh` script will overwrite existing `.git/hooks` files with copies from `docs/hooks`.
