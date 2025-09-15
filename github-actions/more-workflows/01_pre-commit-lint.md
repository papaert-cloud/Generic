# Pre-commit Lint & Static Checks

Purpose: Run language-specific linters and static checks on PRs to catch quality and simple security issues early.

Key checks included:
- `gofmt`, `go vet` for Go
- `bandit` for Python
- `eslint` for JavaScript if `package.json` present

How to enable locally (WSL):
```bash
# install tools
go install golang.org/x/tools/cmd/gofmt@latest
pip install bandit
npm ci
```

Notes: Add pre-commit hooks for local checks to reduce CI feedback loop.
