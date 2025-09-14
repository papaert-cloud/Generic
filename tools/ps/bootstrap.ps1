param(
  [string]$Project = "superlab",
  [string]$Org = "cs",
  [string[]]$Environments = @("dev","test","prod","sandbox")
)

$Root = (Resolve-Path "$PSScriptRoot/../../").Path

function Ensure-Dir($p){ if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }

# 1) Core directories
$paths = @(
  "config","solutions/common/terraform-modules","solutions/common/scripts",
  "pipelines/github/shared/composite-actions",
  "tests/smoke","tests/e2e",
  "tools/ps/templates/scenario","tools/ps/templates/docs","tools/ps/templates/solution/tfroot","tools/ps/templates/solution/pipeline",
  "docs","scenarios"
 ) | ForEach-Object { Join-Path $Root $_ }

$paths | ForEach-Object { Ensure-Dir $_ }

# 2) .gitignore (idempotent append)
$gitIgnore = Join-Path $Root ".gitignore"
$ignoreLines = @(
  "docs/",
  "scenarios/",
  ".vscode/",
  "*.code-workspace",
  ".DS_Store",
  "__pycache__/",
  "*.pyc",
  "node_modules/",
  "bin/",
  "obj/"
)
if(-not (Test-Path $gitIgnore)){ New-Item -Path $gitIgnore -ItemType File | Out-Null }
$existing = Get-Content $gitIgnore -ErrorAction SilentlyContinue
$ignoreLines | Where-Object { $_ -notin $existing } | Add-Content $gitIgnore

# 3) config seeds
$metaPath = Join-Path $Root "config/lab.meta.yaml"
if(-not (Test-Path $metaPath)){
@"
project: $Project
org: $Org
environments: [$($Environments -join ', ')]
resource_naming: "cs-{project}-{env}-{service}-{component}-{suffix}"
scenario_index_start: 1
"@ | Set-Content -Path $metaPath -Encoding UTF8
}

$envSample = Join-Path $Root "config/env.sample.psd1"
if(-not (Test-Path $envSample)){
@"
@{
  DefaultEnvironment = "dev"
  AWSRegion          = "us-east-1"
  AccountAliases     = @{
    dev     = "cs-superlab-dev"
    test    = "cs-superlab-test"
    prod    = "cs-superlab-prod"
    sandbox = "cs-superlab-sbx"
  }
}
"@ | Set-Content -Path $envSample -Encoding UTF8
}

$registry = Join-Path $Root "config/registry.json"
if(-not (Test-Path $registry)){
@"
{
  "nextMajor": 1,
  "scenarios": []
}
"@ | Set-Content -Path $registry -Encoding UTF8
}

# 4) Template seeds (lightweight)
$tmplBase = Join-Path $Root "tools/ps/templates"
Ensure-Dir (Join-Path $tmplBase "scenario")
Ensure-Dir (Join-Path $tmplBase "docs")
Ensure-Dir (Join-Path $tmplBase "solution/tfroot")

@"
# SCENARIO {{ID}} — {{TITLE}}

> Preserve original S.T.A.R.T.Y here (uncommitted).  
> Index: {{INDEX}}

## Situation
## Task
## Actions
## Results
## Takeaways
## Yours
"@ | Set-Content (Join-Path $tmplBase "scenario/STARTY.md.tmpl") -Encoding UTF8

@"
# {{TITLE}} ({{ID}})

**Slug:** {{SLUG}}  
**Index:** {{INDEX}}

## Overview
- Goal:
- Inputs:
- Outputs:
- Success criteria:

## Components
- IaC root: `solutions/{{SCENARIO_DIR}}/iac/terraform`
- Pipelines: `solutions/{{SCENARIO_DIR}}/pipelines`
- Tests: `solutions/{{SCENARIO_DIR}}/tests`

## How to run
1. Pre-flight: `pwsh -c 'Import-Module ./tools/ps/LabCtl.psm1; Test-Tooling'`
2. Generate tfvars: `New-LabVariables -Scenario {{ID}} -Env dev`
3. Plan/apply: `Invoke-Lab -Scenario {{ID}} -Env dev -Action plan|apply`
"@ | Set-Content (Join-Path $tmplBase "scenario/README.md.tmpl") -Encoding UTF8

@"
{
  "id": "{{ID}}",
  "slug": "{{SLUG}}",
  "title": "{{TITLE}}",
  "index": "{{INDEX}}",
  "status": "draft",
  "tags": ["teaching","security","devsecops"],
  "created": "{{ISO_NOW}}"
}
"@ | Set-Content (Join-Path $tmplBase "scenario/meta.json.tmpl") -Encoding UTF8

@"
# {{TOPIC}} — Concept Notes

## What problem does this solve?
## Mental model (analogy)
## Key terms
## Pitfalls & best practices
"@ | Set-Content (Join-Path $tmplBase "docs/concept.md.tmpl") -Encoding UTF8

@"
# Runbook — {{NAME}}

## Preconditions
## Steps
## Expected outputs
## Rollback / Self-healing
"@ | Set-Content (Join-Path $tmplBase "docs/runbook.md.tmpl") -Encoding UTF8

@"
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Example reusable module usage (placeholder)
# module "example" {
#   source = "../../solutions/common/terraform-modules/example"
#   name   = var.name
#   tags   = var.tags
# }
"@ | Set-Content (Join-Path $tmplBase "solution/tfroot/main.tf.tmpl") -Encoding UTF8

@"
variable "name"   { type = string }
variable "region" { type = string }
variable "tags"   { type = map(string) default = {} }
"@ | Set-Content (Join-Path $tmplBase "solution/tfroot/variables.tf.tmpl") -Encoding UTF8

@"
output "name" { value = var.name }
"@ | Set-Content (Join-Path $tmplBase "solution/tfroot/outputs.tf.tmpl") -Encoding UTF8

Write-Host "Bootstrap template seeds created"
