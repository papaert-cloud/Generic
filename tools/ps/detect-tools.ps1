param(
  [switch]$WriteReport
)

$report = [ordered]@{
  Timestamp          = (Get-Date).ToString("s")
  OS                 = (Get-CimInstance Win32_OperatingSystem).Caption 2>$null
  PowerShellVersion  = $PSVersionTable.PSVersion.ToString()
  IsWSL              = (Get-ChildItem Env:WSL_DISTRO_NAME -ErrorAction SilentlyContinue).Value -ne $null
  Git                = (git --version 2>$null)
  Terraform          = (terraform version 2>$null | Select-String "Terraform v").ToString()
  Terragrunt         = (terragrunt --version 2>$null | Select-String "terragrunt version").ToString()
  TFLint             = (tflint --version 2>$null)
  Checkov            = (checkov --version 2>$null)
  Infracost          = (infracost --version 2>$null)
  AWSCLI             = (aws --version 2>$null)
  AzureCLI           = (az --version 2>$null | Select-String "azure-cli").ToString()
  GCloudCLI          = (gcloud --version 2>$null | Select-String "Google Cloud SDK").ToString()
  Node               = (node --version 2>$null)
  Python             = (python --version 2>$null)
  Docker             = (docker --version 2>$null)
  VSCode             = (code --version 2>$null | Select-Object -First 1)
  VSCodeExtensions   = @()
}

try {
  $ext = code --list-extensions 2>$null
  if ($ext) { $report.VSCodeExtensions = $ext }
} catch { }

if ($WriteReport) {
  $outDir = Join-Path (Resolve-Path "$PSScriptRoot/../../docs").Path "environment"
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  $outFile = Join-Path $outDir "tooling-$(Get-Date -Format yyyyMMdd-HHmmss).json"
  $report | ConvertTo-Json -Depth 5 | Set-Content -Path $outFile -Encoding UTF8
  Write-Host "Wrote report: $outFile"
} else {
  $report | ConvertTo-Json -Depth 5
}
