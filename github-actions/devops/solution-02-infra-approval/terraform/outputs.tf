output "ecr_repository" {
  value = aws_ecr_repository.app.repository_url
}

output "artifact_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "github_ecr_push_role_arn" {
  value = aws_iam_role.github_ecr_push.arn
}

output "kms_key_arn" {
  value = aws_kms_key.artifacts.arn
}
