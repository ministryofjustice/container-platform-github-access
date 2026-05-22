# Container Platform GitHub Access

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/container-platform-github-access/badge)](https://github-community.service.justice.gov.uk/repository-standards/container-platform-github-access)

Infrastructure as Code repository for managing the Container Platform team's GitHub repositories

## Runbooks

- [Adding a new repository](runbooks/adding-github-resources.md)

## Running Locally

> [!IMPORTANT]
> Only [@ministryofjustice/cloud-platform-engineers](https://github.com/orgs/ministryofjustice/teams/cloud-platform-engineers) can do this

### Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) (~> 1.10)
- [GitHub CLI](https://cli.github.com/), authenticated with `repo` and `read:org` scopes

### Authenticate with GitHub

Export a GitHub token for the Terraform provider:

```bash
export TF_VAR_github_token="$(gh auth token)"
```

## CI/CD

The GitHub Actions workflow (`.github/workflows/terraform.yml`) handles authentication using the **Container Platform Access** GitHub App. It runs:

- use `terraform plan` on pull requests
- use `terraform apply` on merge to `main`

## Contributing

The base branch (`main`) requires all commits to be signed. Learn more about signing commits in [GitHub's documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification).

## Importing repositories

### Methodology

Repository imports are managed through Terraform configuration and reviewed via pull requests. This approach is preferred over ad-hoc CLI imports because it makes changes visible for peer review and ensures imports are applied consistently through CI.

An important rule when importing repositories, _Check a repositories settings before you import them_

### Step 1: Query the repositories current & Amend the config to match the current repository

To find information about a repository use `gh api` "repos/ministryofjustice/REPO_NAME" ...

```bash
# Basic settings
gh api "repos/ministryofjustice/REPO_NAME" --jq '{description, visibility, has_wiki, has_projects, has_issues, has_discussions, is_template, homepage_url, web_commit_signoff_required}'

#Team access
gh api "repos/ministryofjustice/REPO_NAME/teams" --jq '.[] | "(.slug) (id: (.id), permission: (.permission))"'

#Existing rulesets
gh api "repos/ministryofjustice/REPO_NAME/rulesets" --jq '.[] | {name, id, enforcement}'
```

You can then add those details to the `github-repositories.tf` file, [example here](https://github.com/ministryofjustice/container-platform-github-access/pull/36/changes#diff-78786040683a4d6acb5f292bdcc638c0d91fbdf8d585c9c228fcd553ffb2a494R67)

### Step 2: Create Import Blocks

Create `imports.tf` with import blocks for resources that **already exist** on GitHub:

```hcl
# Repository
import {
  to = module.github_repositories["REPO_KEY"].github_repository.this
  id = "REPO_NAME"
}

# Dependabot (if accessible)
import {
  to = module.github_repositories["REPO_KEY"].github_repository_dependabot_security_updates.this
  id = "REPO_NAME"
}

# Existing team access
import {
  to = module.github_repositories["REPO_KEY"].github_team_repository.admin["TEAM_ID"]
  id = "TEAM_ID:REPO_NAME"
}
```

**Do NOT create import blocks for:**

- New teams being added (these will be created by Terraform)
- Resources returning 403s (remove from config or fix app permissions first)

**Do create import blocks for:**

- Existing team access (check with `gh api`)
- Existing branch rulesets (check with `gh api`)
- Dependabot (if accessible and already enabled)
