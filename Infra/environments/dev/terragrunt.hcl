include {
  path = find_in_parent_folders()
}

inputs = {
  lambda_code_bucket      = "my-deployment-bucket"
  administration_role_arn = "arn:aws:iam::005965605891:role/OrganizationAccountAccessRole"
  target_account_ids      = ["111111111111"]
}
