# 🚀 AWS OIDC Integration Setup Guide

This guide contains the configurations required to establish a secure, keyless OpenID Connect (OIDC) handshake between GitHub Actions and global AWS regions (e.g., `ap-south-1`). This setup eliminates the need for long-lived AWS Access Keys.

---

## 🛠️ Part 1: AWS IAM Configuration

Before running the pipeline, you must configure AWS to trust GitHub as an Identity Provider.

### 1. Create the Identity Provider
In the AWS Console, navigate to **IAM > Identity providers > Add provider**:
* **Provider type:** `OpenID Connect`
* **Provider URL:** `https://token.actions.githubusercontent.com`
* **Audience:** `sts.amazonaws.com`

### 2. Create the IAM Role Trust Policy
Create an IAM Role named `github-action-role` and attach the following **Trust Policy**.

> ⚠️ **Configuration Note:** Replace `your-org/your-repo` with your actual GitHub Organization/Username and Repository name.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::299295683811:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:your-org/your-repo:ref:refs/heads/aws-oidc-test"
        }
      }
    }
  ]
}
```

## 💻 Part 2: GitHub Actions Workflow
Create a file named .github/workflows/main.yml in your repository and use the configuration below:

```yaml
name: GitHub AWS OIDC

on:
  push:
    branches: [aws-oidc-test]

# Permissions required to orchestrate the OIDC handshake
permissions:
  id-token: write   # Required to request the JWT token from GitHub
  contents: read    # Required for actions/checkout to read repository code

jobs:
  oidc-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source
        uses: actions/checkout@v4

      - name: Configure AWS Credentials using OIDC
        uses: aws-actions/configure-aws-credentials@v4.1.0
        with:
          aws-region: ap-south-1 
          role-to-assume: arn:aws:iam::299295683811:role/github-action-role
          # Alternative: role-to-assume: ${{ secrets.AWS_IAM_ROLE }} -> Role can be added as a GitHub secret/variable

      # Sanity check to verify identity context ("Who am I right now?")
      - name: Test AWS Credentials
        run: aws sts get-caller-identity
```
---


        
