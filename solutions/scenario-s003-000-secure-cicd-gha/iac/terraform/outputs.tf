output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "deployer_role_arn" {
  value = aws_iam_role.gha_deployer.arn
}
