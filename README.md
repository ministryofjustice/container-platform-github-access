# Cloud Platform GitHub Access

Infrastructure as Code repository for managing the Container Platform's GitHub resources

## Runbooks

- Adding a new repository (runbooks/adding-github-resources.md)

---

## Running Locally

IMPORTANT:
Only @ministryofjustice/cloud-platform can do this:
<https://github.com/orgs/ministryofjustice/teams/cloud-platform-engineers>

### Prerequisites

Ensure the following requirements are met before running locally.

---

### Initialise project

1. Ensure prerequisites are met

2. Create virtual environment
   uv venv

3. Sync dependencies
   uv sync --frozen

4. Initialise pre-commit
   pre-commit install

---

## AWS Authentication

### AWS CLI

1. Ensure prerequisites are met

A) Copy and paste credentials from AWS Single Sign On:
<https://moj.awsapps.com/start>

OR

B) Use AWS SSO configuration:

aws configure sso --profile data-platform-development:platform-engineer-admin

SSO session name: moj
SSO start URL: <https://moj.awsapps.com/start>
SSO region: eu-west-2
SSO registration scopes: sso:account:access

---

### AWS SSO CLI

WARNING: Logging in may take several minutes if you have many AWS accounts

1. Ensure prerequisites are met

2. Log in
   aws-sso login

3. Select profile
   aws-sso exec --profile cloud-platform-development:platform-engineer-admin

---

## Terraform

1. Ensure prerequisites are met

2. Authenticate with AWS

3. Initialise
   terraform init

4. Validate
   terraform validate

5. Plan
   terraform plan

6. Apply
   terraform apply