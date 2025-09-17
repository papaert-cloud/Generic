# Generic

This repository contains a collection of documentation, scripts, and example solutions for cloud-native demos and secure CI/CD patterns.

Contents overview
- `docs/` — project documentation and scenario guides.
- `solutions/` — example solutions and labs (for example `solutions/demo-sbom-lab`).
- `Infra/` — infrastructure blueprints and environment notes.
- `github-actions/` and `.github/workflows/` — CI/CD workflows used by the repository.
- `tools/` and `scripts/` — helper scripts for bootstrapping and maintenance.

Quickstart
1. Inspect documentation: see `docs/index.md` and `docs/README.md` for repository orientation.
2. Run examples: many solutions include step-by-step instructions in their `README.md` files (for example `solutions/demo-sbom-lab/README.md`).
3. Local checks: The repo uses GitHub Actions for CI and suggests local `pre-commit` tooling. Install `pre-commit` if you plan to run local hooks.

Example commands

- Clone the repo and switch to your feature branch:

```bash
git clone https://github.com/papaert-cloud/Generic.git
cd Generic
git checkout -b my-feature-branch
```

- Make changes, run pre-commit locally (recommended):

```bash
# install pre-commit if you don't have it
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

- Commit and open a pull request:

```bash
git add .
git commit -m "Describe your change"
git push --set-upstream origin my-feature-branch
# then open a PR on GitHub: https://github.com/papaert-cloud/Generic/compare
```

Contributing
- Follow repository conventions in `docs/` and `github-actions/`.
- Use feature branches and open pull requests against `main` (protected).
- Keep commits focused and tests passing. If you hit a commit hook or CI check, fix the reported linter/test failures before pushing.

Branch protection and CI checks
- This repository enforces branch protection rules. Direct pushes to protected branches may be blocked. Changes should be submitted via pull requests.
- Required checks can include Code Scanning and other GitHub Actions workflows — the PR must pass required status checks before it can be merged.

Troubleshooting push rejections
- If you see a remote rejection mentioning repository rules (GH013), create a PR instead of pushing directly.
- If Code Scanning is required and not yet complete, wait for the scanning workflow to finish, or ask an admin to adjust the rules if appropriate.

Contact and support
- See `docs/README.md` and `recap/` for notes and recent changes.
# Generic

This repository contains a collection of documentation, scripts, and example solutions for cloud-native demos and secure CI/CD patterns.

Contents overview
- `docs/` — project documentation and scenario guides.
- `solutions/` — example solutions and labs (for example `solutions/demo-sbom-lab`).
- `Infra/` — infrastructure blueprints and environment notes.
- `github-actions/` and `.github/workflows/` — CI/CD workflows used by the repository.
- `tools/` and `scripts/` — helper scripts for bootstrapping and maintenance.

Quickstart
1. Inspect documentation: see `docs/index.md` and `docs/README.md` for repository orientation.
2. Run examples: many solutions include step-by-step instructions in their `README.md` files (for example `solutions/demo-sbom-lab/README.md`).
3. Local checks: The repo uses GitHub Actions for CI and suggests local `pre-commit` tooling. Install `pre-commit` if you plan to run local hooks.

Contributing
- Follow repository conventions in `docs/` and `github-actions/`.
- Use feature branches and open pull requests against `main`.
- Keep commits focused and tests passing. If you hit a commit hook or CI check, fix the reported linter/test failures before pushing.

Contact and support
- See `docs/README.md` and `recap/` for notes and recent changes.

