# GitHub Access Manager: Repository Setup and Architecture

## Overview

The `container-platform-github-access` repository is a Terraform-managed repository that controls GitHub repository settings, team access, branch protection rulesets, and compliance standards for all Container Platform repositories.

> ⚠️ Never import a repository without first checking its current settings.
>
> Terraform will overwrite anything that does not match your configuration.
> Missing a setting could break a live site, remove team access, or destroy rulesets.

## Architecture

### State Backend

- **S3 bucket**: `cloud-platform-terraform-state`
- **State key**: `container-platform-github-access/terraform.tfstate`
- **Region**: `eu-west-1`
- **Locking**: `use_lockfile = true` (native S3 state locking, no DynamoDB)

### GitHub App

- **Name**: Container Platform Access
- **Permissions**: Administration, Contents, Issues, Pages, Pull requests (repo-level); Administration, Members (org-level)
- **Scoped repos**: The app is installed on specific repos only. Repos not in the app's installation scope will return 403 errors.
- **Secrets**: `CLIENT_ID` and `APP_PRIVATE_KEY` stored as GitHub Actions secrets (and duplicated as Dependabot secrets for Dependabot PRs)

### Directory Structure

```text
container-platform-github-access/
  terraform.tf                # Backend config, provider setup
  variables.tf                # GitHub token and owner variables
  data.tf                     # Data sources for existing teams
  github-teams.tf             # Container Platform team definition
  github-repositories.tf      # All managed repos and module calls
  imports.tf                  # Temporary import blocks (delete after apply)
  modules/
    github/
      repository/             # Repo module (settings, rulesets, access)
        main.tf
        variables.tf
        outputs.tf
      team/                   # Team module (team creation, membership)
        main.tf
        variables.tf
        outputs.tf
        providers.tf
```

## Team Hierarchy (for compliance)

The compliance badge requires an admin team with a parent chain back to `business-units`:

```text
Business Units
  └── Office of the CTO
        └── OCTO Hosting
              └── Container Platform   <-- admin on all managed repos
```

- `Office of the CTO` and `OCTO Hosting` are managed in the `octo-access` repository
- `Container Platform` is managed in `container-platform-github-access`

## Compliance Requirements

For the "Exemplar" badge:

- Admin team with parent chain to `business-units`
- `webops` team with admin access (currently required by the compliance checker)
- Branch protection ruleset on default branch
- Signed commits required
- Code owner review required
- Stale review dismissal enabled

## What the Repository Module Creates

For each repository in the locals map:

1. `github_repository`: repository with all settings
2. `github_repository_ruleset`: branch protection on default branch
3. `github_repository_dependabot_security_updates`: dependabot enabled
4. `github_team_repository` (admin): admin team access
5. `github_team_repository` (pushers): push team access

---

**Last reviewed:** 26 May 2026
