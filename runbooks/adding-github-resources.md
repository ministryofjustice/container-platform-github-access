# Runbook: Adding a New Repository

This runbook explains how to add:

- a new GitHub repository and grant team access

## What is configurable

### Repository behaviour and access

- Repository catalogue and per-repository settings:
  - [github-repositories.tf](../github-repositories.tf)
- Full list of supported repository feature flags/defaults:
  - [modules/github/repository/variables.tf](../modules/github/repository/variables.tf)
- Resource implementation details (rulesets, security, access bindings):
  - [modules/github/repository/main.tf](../modules/github/repository/main.tf)

### Team data sources

- Teams used for access control are defined as data sources in:
  - [data.tf](../data.tf)

## Before you start

1. Ensure local setup and authentication per [README.md](../README.md).
2. Create a feature branch.

## Add a new repository

Repositories are defined in `github-repositories.tf`
in `local.github_repositories`.

### 1. Add a repository entry

Add a new map entry under `local.github_repositories`.

Example:

```hcl
container_platform_my_new_repo = {
  name         = "container-platform-my-new-repo"
  description  = "Repository for ..."
  has_projects = true
  access = {
    admins  = [data.github_team.cloud_platform_engineers.id]
    pushers = [data.github_team.all_org_members.id]
  }
}
```

Common options already used in this repository:

- `visibility` (`public` or `private`, defaults to `public`)
- `has_discussions`
- `pages_enabled`
- `pages_configuration = { cname = "..." }`

### 2. Reference the correct team data sources

Teams are defined as `data "github_team"` blocks in `data.tf`. Use them in access blocks:

- `data.github_team.cloud_platform_engineers.id` (admin access)
- `data.github_team.all_org_members.id` (push access, org-wide)

If a new team is needed, add a `data "github_team"` block in `data.tf` first.

### 3. Importing an existing repository

If the repository already exists on GitHub, you must import it into Terraform state before applying. Otherwise, Terraform will attempt to create a duplicate and fail.

#### Option A: Import blocks (recommended, for CI)

Add `import` blocks to an `imports.tf` file. These can be removed after the first successful apply:

```hcl
import {
  to = module.github_repositories["my-existing-repo"].github_repository.this
  id = "my-existing-repo"
}

# Import existing team access if applicable
import {
  to = module.github_repositories["my-existing-repo"].github_team_repository.admin["12737405"]
  id = "12737405:my-existing-repo"
}
```

#### Option B: CLI import (for local testing)

```bash
terraform import \
  'module.github_repositories["my-existing-repo"].github_repository.this' \
  my-existing-repo
```

After importing, run `terraform plan` and review the diff carefully before applying. Fix any config mismatches to avoid unintended changes to the repository.

> [!NOTE]
> Existing repositories will have `use_template` default to `false` in the module call.
> Do not set `use_template = true` for repos that already exist. This will cause an error.

## Validate changes

```bash
terraform init
terraform validate
terraform plan
```

## Open a PR

1. Commit changes with a clear message.
2. Open a PR describing:
   - repository added/changed
   - access model (admin/push teams)
3. The CI workflow will run `terraform plan` automatically on the PR.

## Troubleshooting

- **`terraform plan` shows "will be created" for an existing repository**:
  - The repository hasn't been imported into state. See [Importing an existing repository](#3-importing-an-existing-repository).
- **Error about template on existing repository**:
  - Ensure `use_template` is not set to `true` for repositories that already exist.
- **GitHub repository access not applied**:
  - Check `access` keys reference valid `data.github_team` data sources in `data.tf`.
- **Auth errors during plan/apply**:
  - Locally: ensure `TF_VAR_github_token` is exported.
  - CI: check that `CLIENT_ID` and `APP_PRIVATE_KEY` repository secrets are set correctly.
