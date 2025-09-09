using namespace System.IO

$script:Root = (Resolve-Path "$PSScriptRoot/../../").Path
$script:ConfigDir = Join-Path $script:Root "config"
$script:Templates = Join-Path $script:Root "tools/ps/templates"

function Read-Json($path){ Get-Content $path -Raw | ConvertFrom-Json }
function Write-Json($obj,$path){ $obj | ConvertTo-Json -Depth 10 | Set-Content -Path $path -Encoding UTF8 }
function Ensure-Dir($p){ if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }

function Test-Tooling {
  [CmdletBinding()]
  param()
  $checks = @(
    @{ Name="git";        Cmd="git --version";       Match="git version" },
    @{ Name="terraform";  Cmd="terraform version";   Match="Terraform v" },
    @{ Name="tflint";     Cmd="tflint --version";    Match="TFLint" },
    @{ Name="checkov";    Cmd="checkov --version";   Match="version" },
    @{ Name="infracost";  Cmd="infracost --version"; Match="Infracost" },
    @{ Name="aws";        Cmd="aws --version";       Match="aws-cli" }
  )
  $results = foreach($c in $checks){
    try {
      $o = Invoke-Expression $c.Cmd 2>$null
      [pscustomobject]@{ Tool=$c.Name; Present=($o -match $c.Match); Raw=$o -replace "`n"," " }
    } catch {
      [pscustomobject]@{ Tool=$c.Name; Present=$false; Raw=$_ .Exception.Message }
    }
  }
  $results | Format-Table -AutoSize
  $missing = $results | Where-Object { -not $_.Present } | Select-Object -ExpandProperty Tool
  if($missing){ Write-Warning "Missing tools: $($missing -join ', ')" } else { Write-Host "All baseline tools detected." -ForegroundColor Green }
}

function Get-Registry {
  $path = Join-Path $script:ConfigDir "registry.json"
  if(-not (Test-Path $path)){ throw "registry.json missing. Run bootstrap." }
  return Read-Json $path
}

function Save-Registry($reg){
  $path = Join-Path $script:ConfigDir "registry.json"
  Write-Json $reg $path
}

function New-LabScenario {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$Title,
    [Parameter(Mandatory)] [string]$Slug
  )
  $reg = Get-Registry
  $idNum = [int]$reg.nextMajor
  $id = "S{0:D3}" -f $idNum
  $index = $idNum
  $now = (Get-Date).ToString("s")

  $item = [ordered]@{
    id     = $id
    slug   = $Slug
    title  = $Title
    index  = $index
    status = "draft"
    created= $now
  }
  $reg.scenarios += $item
  $reg.nextMajor = $idNum + 1
  Save-Registry $reg

  $scDirName = "scenario-$($id.ToLower())-$Slug"
  $solutionDir = Join-Path $script:Root "solutions/$scDirName"
  $iacDir      = Join-Path $solutionDir "iac/terraform"
  $pipDir      = Join-Path $solutionDir "pipelines"
  $tstDir      = Join-Path $solutionDir "tests"
  $notesDir    = Join-Path $script:Root "scenarios/$id-$Slug"

  foreach($p in @($solutionDir,$iacDir,$pipDir,$tstDir,$notesDir)){ Ensure-Dir $p }

  $map = @{
    "{{ID}}"          = $id
    "{{SLUG}}"        = $Slug
    "{{TITLE}}"       = $Title
    "{{INDEX}}"       = $index
    "{{SCENARIO_DIR}}"= $scDirName
    "{{ISO_NOW}}"     = $now
  }

  $tmpl = Join-Path $script:Templates "scenario/STARTY.md.tmpl"
  (Get-Content $tmpl -Raw) | ForEach-Object { $_ } | ForEach-Object {
    $line = $_; foreach($k in $map.Keys){ $line = $line -replace [regex]::Escape($k), $map[$k] }; $line
  } | Set-Content (Join-Path $notesDir "STARTY.md") -Encoding UTF8

  $tmpl = Join-Path $script:Templates "scenario/README.md.tmpl"
  (Get-Content $tmpl -Raw) | ForEach-Object {
    $line = $_; foreach($k in $map.Keys){ $line = $line -replace [regex]::Escape($k), $map[$k] }; $line
  } | Set-Content (Join-Path $solutionDir "README.md") -Encoding UTF8

  $tmpl = Join-Path $script:Templates "scenario/meta.json.tmpl"
  (Get-Content $tmpl -Raw) | ForEach-Object {
    $line = $_; foreach($k in $map.Keys){ $line = $line -replace [regex]::Escape($k), $map[$k] }; $line
  } | Set-Content (Join-Path $solutionDir "meta.json") -Encoding UTF8

  $tfRoot = Join-Path $script:Templates "solution/tfroot"
  Copy-Item (Join-Path $tfRoot "main.tf.tmpl")      (Join-Path $iacDir "main.tf")      -Force
  Copy-Item (Join-Path $tfRoot "variables.tf.tmpl") (Join-Path $iacDir "variables.tf") -Force
  Copy-Item (Join-Path $tfRoot "outputs.tf.tmpl")   (Join-Path $iacDir "outputs.tf")   -Force

  Write-Host "Created $id ($Title) at $solutionDir"
}

function New-LabVariables {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$Scenario,
    [Parameter(Mandatory)] [ValidateSet("dev","test","prod","sandbox")] [string]$Env,
    [string]$Region = "us-east-1"
  )
  $scDir = Get-ChildItem -Directory (Join-Path $script:Root "solutions") | Where-Object { $_.Name -like "scenario-$($Scenario.ToLower())-*" } | Select-Object -First 1
  if(-not $scDir){ throw "Scenario $Scenario not found" }
  $iac = Join-Path $scDir.FullName "iac/terraform"
  Ensure-Dir $iac
  $tfvars = @"
name   = "$Scenario-$Env"
region = "$Region"
tags = {
  Project = "superlab"
  Scenario= "$Scenario"
  Env     = "$Env"
  Owner   = "Peter"
}
"@
  $out = Join-Path $iac "$Env.auto.tfvars"
  $tfvars | Set-Content -Path $out -Encoding UTF8
  Write-Host "Wrote $out"
}

function Invoke-Lab {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$Scenario,
    [Parameter(Mandatory)] [ValidateSet("dev","test","prod","sandbox")] [string]$Env,
    [Parameter(Mandatory)] [ValidateSet("plan","apply","destroy")] [string]$Action
  )
  $scDir = Get-ChildItem -Directory (Join-Path $script:Root "solutions") | Where-Object { $_.Name -like "scenario-$($Scenario.ToLower())-*" } | Select-Object -First 1
  if(-not $scDir){ throw "Scenario $Scenario not found" }
  $iac = Join-Path $scDir.FullName "iac/terraform"
  if(-not (Test-Path (Join-Path $iac ".terraform"))){ Push-Location $iac; terraform init; Pop-Location }

  Push-Location $iac
  switch($Action){
    "plan"    { terraform plan }
    "apply"   { terraform apply -auto-approve }
    "destroy" { terraform destroy -auto-approve }
  }
  Pop-Location
}
Export-ModuleMember -Function *-*
