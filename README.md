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

