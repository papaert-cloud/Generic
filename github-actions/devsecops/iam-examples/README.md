# IAM examples and CLI commands for GitHub Actions workflows

This folder contains example IAM trust documents and inline policies you can use as a starting point to create the AWS resources and roles GitHub Actions needs to run SBOM/SCA, push to ECR, sign with KMS, and import to Security Hub.

Replace placeholders like `ACCOUNT_ID`, `AWS_REGION`, `my-org-artifacts`, and the GitHub `repo` (`papaert-cloud/Generic`) before running the commands.

Important: review and adapt policies to your security requirements (least privilege, condition on `aud`, `sub`, branch, etc.).

1. Create S3 artifact bucket (example)

```bash
# set variables
ACCOUNT_ID=005965605891
AWS_REGION=us-east-1
REPO="papaert-cloud/Generic"
ARTIFACT_BUCKET=my-org-artifacts

# create bucket (change command for us-east-1 if necessary)
aws s3api create-bucket --bucket ${ARTIFACT_BUCKET} --region ${AWS_REGION} --create-bucket-configuration LocationConstraint=${AWS_REGION}
```

2. Create GitHub OIDC role for S3 PutObject

Save the trust doc to `s3-artifact-role-trust.json` (example in this folder) then:

```bash
aws iam create-role --role-name GitHubActionsS3PutObjectRole \
  --assume-role-policy-document file://github-actions/devsecops/iam-examples/s3-artifact-role-trust.json

aws iam put-role-policy --role-name GitHubActionsS3PutObjectRole \
  --policy-name S3ArtifactPutPolicy --policy-document file://github-actions/devsecops/iam-examples/s3-artifact-policy.json
```

3. Create ECR push role

```bash
aws iam create-role --role-name GitHubActionsECRPush \
  --assume-role-policy-document file://github-actions/devsecops/iam-examples/ecr-push-role-trust.json

aws iam put-role-policy --role-name GitHubActionsECRPush \
  --policy-name ECRPushPolicy --policy-document file://github-actions/devsecops/iam-examples/ecr-push-policy.json
```

4. Create KMS key for cosign (recommended alias)

```bash
# create key with an account-level policy or use a simpler create and then grant the role
KEY_ID=$(aws kms create-key --description "Cosign key for GitHub Actions" --query KeyMetadata.KeyId --output text)
aws kms create-alias --alias-name alias/github-actions-cosign --target-key-id ${KEY_ID}

# Optionally create a grant for the GitHub Actions role to use Sign/Encrypt
aws kms create-grant --key-id ${KEY_ID} --grantee-principal arn:aws:iam::${ACCOUNT_ID}:role/GitHubActionsKMSSign --operations Sign Encrypt --name GitHubCosignGrant
```

5. Create Security Hub role (for importing findings)

```bash
aws iam create-role --role-name GitHubActionsSecurityHubImport \
  --assume-role-policy-document file://github-actions/devsecops/iam-examples/securityhub-role-trust.json

aws iam put-role-policy --role-name GitHubActionsSecurityHubImport \
  --policy-name SecurityHubImportPolicy --policy-document file://github-actions/devsecops/iam-examples/securityhub-policy.json
```

6. Set GitHub repository secrets (using `gh` CLI)

Make sure `gh` is authenticated and has repo admin permissions.

```bash
# set artifact bucket name
gh secret set ARTIFACT_BUCKET -b"${ARTIFACT_BUCKET}" -R papaert-cloud/Generic

# set KMS key ARN for cosign usage
# example ARN: arn:aws:kms:us-east-1:${ACCOUNT_ID}:key/${KEY_ID}
gh secret set KMS_KEY_ARN -b"arn:aws:kms:${AWS_REGION}:${ACCOUNT_ID}:key/${KEY_ID}" -R papaert-cloud/Generic

# set DAST target URL (if using DAST workflow)
gh secret set DAST_TARGET_URL -b"https://staging.example.com" -R papaert-cloud/Generic

# set SONAR token if using Sonar
# gh secret set SONAR_TOKEN -b"$(cat ~/secrets/sonar.token)" -R papaert-cloud/Generic
```

Notes

- After creating roles, update your workflows to reference the created role ARNs where needed (e.g. `role-to-assume` for `aws-actions/configure-aws-credentials@v2`).
- Consider scoping `token.actions.githubusercontent.com:sub` condition to branches or workflows for tighter security (see trust docs below).

Terraform import (optional)

If an OIDC provider already exists and you prefer Terraform to manage it, import it into state instead of creating a new one:

```bash
# discover provider ARN
aws iam list-open-id-connect-providers --query 'OpenIDConnectProviderList[].Arn' --output text

# import into Terraform (run where terraform config is). If you are using the module that manages the provider
# the resource address will be `module.github_oidc.aws_iam_openid_connect_provider.maybe_create[0]`. Example:
terraform import module.github_oidc.aws_iam_openid_connect_provider.maybe_create[0] arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com

Note: If you set `create_oidc_provider = false` in the module, the module will reference an existing provider and you do NOT need to import. If you set `create_oidc_provider = true` and provider already exists, import the provider into the module resource address shown above before applying.
```
