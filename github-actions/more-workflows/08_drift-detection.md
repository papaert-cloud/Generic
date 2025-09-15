# Terraform Drift Detection

Purpose: Detect configuration drift between IaC desired state and live resources.

Process:
- Periodic `terraform plan` runs and compare current state
- Create issue or alert if drift detected
