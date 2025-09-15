param(
  [Parameter(Mandatory=$false)][string]$OutFile = ".\terraform.tfvars",
  [Parameter(Mandatory=$false)][string]$Owner = $env:GITHUB_REPOSITORY_OWNER,
  [Parameter(Mandatory=$false)][string]$Repo = $(($env:GITHUB_REPOSITORY -split "/")[-1]),
  [Parameter(Mandatory=$false)][string]$Region = "us-east-1"
)

$tfvars = @"
aws_region = "$Region"
github_owner = "$Owner"
github_repo = "$Repo"
allowed_refs = ["refs/heads/main"]
github_oidc_thumbprints = ["AABBCCDDEEFF00112233445566778899AABBCCDD"]
role_name = "GA-Deployer"
"@

$tfvars | Set-Content -Path $OutFile -Encoding UTF8
Write-Host "Wrote $OutFile"
