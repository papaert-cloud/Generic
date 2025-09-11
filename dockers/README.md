# superlab — Super-Laboratory

This repository is a local-first Super-Laboratory scaffold for experimenting with cloud scenarios, infrastructure, and teaching materials. The `docs/` and `scenarios/` folders are ignored by default so your notes stay local until you decide to commit them.

## Quick start

1. Bootstrap the repo (PowerShell):

   ```powershell
   pwsh -File .\tools\ps\bootstrap.ps1
   Import-Module .\tools\ps\LabCtl.psm1 -Force
   Test-Tooling
   ```

2. Create a new scenario:

   ```powershell
   New-LabScenario -Title "Enforce Org CloudTrail" -Slug "cloudtrail-central"
   ```

3. Generate variables and plan:

   ```powershell
   New-LabVariables -Scenario S001 -Env dev
   Invoke-Lab -Scenario S001 -Env dev -Action plan
   ```

## Repository layout (important folders)

- `config/` — global metadata and registry
- `tools/ps/` — PowerShell control plane and templates
- `solutions/` — code created per scenario (modules, iac roots)
- `pipelines/` — shared CI pieces
- `docs/`, `scenarios/` — local-only knowledge stores (ignored by default)
