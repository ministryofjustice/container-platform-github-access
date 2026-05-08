# Container Platform GitHub Access

Infrastructure as Code repository for managing the Container Platform team's GitHub repositories

## Runbooks

- [Adding a new repository](runbooks/adding-github-resources.md)

## Running Locally

> [!IMPORTANT]
> Only [@ministryofjustice/cloud-platform-engineers](https://github.com/orgs/ministryofjustice/teams/cloud-platform-engineers) can do this

### Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) (~> 1.5)
- [GitHub CLI](https://cli.github.com/), authenticated with `repo` and `read:org` scopes

### Authenticate with GitHub

Export a GitHub token for the Terraform provider:

```bash
export TF_VAR_github_token="$(gh auth token)"
```

### Run Terraform

1. Initialise

   ```bash
   terraform init
   ```

2. Validate

   ```bash
   terraform validate
   ```

3. Plan

   ```bash
   terraform plan
   ```

4. Apply

   ```bash
   terraform apply
   ```

## CI/CD

The GitHub Actions workflow (`.github/workflows/terraform.yml`) handles authentication using the **Container Platform Access** GitHub App. It runs:

- `terraform plan` on pull requests
- `terraform apply` on merge to `main`

## Contributing

The base branch (`main`) requires all commits to be signed. Learn more about signing commits in [GitHub's documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification).