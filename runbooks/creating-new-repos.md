# Runbook: Creating New Repositories

## Overview

The manager repository can create brand new GitHub repositories with all compliance standards applied from day one. No import blocks needed.

## Step 1: Add the Repository Config

Add a new entry to `github-repositories.tf`:

```hcl
container_platform_something_new = {
  name         = "container-platform-something-new"
  description  = "Description of the repo"
  has_projects = true
  access = {
    admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
    pushers = [data.github_team.all_org_members.id]
  }
}
```

## Step 2: Using the Template Repository

To create a repository from `container-platform-terraform-template`, you **must** set `use_template = true`. Without it, the repository is created empty:

```hcl
container_platform_terraform_foo = {
  name         = "container-platform-terraform-foo"
  description  = "Foo Terraform module for the Container Platform"
  use_template = true
  has_projects = true
  access = {
    admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
    pushers = [data.github_team.all_org_members.id]
  }
}
```

The template is hardcoded to:

- **Owner**: `ministryofjustice`
- **Repository**: `container-platform-terraform-template`

These are set in [`modules/github/repository/variables.tf`](../modules/github/repository/variables.tf). To use a different template, modify the module call in `github-repositories.tf` to pass through `template_repository_owner` and `template_repository`.

## Step 3: Optional Settings

Override module defaults as needed:

```hcl
# Internal repo
visibility = "internal"

# Template repo (others can create repos from it)
is_template = true

# GitHub Pages
pages_enabled = true
pages_configuration = {
  cname = "my-site.service.justice.gov.uk"
}

# Discussions
has_discussions = true

# Custom topics
topics = ["custom-topic-1", "custom-topic-2"]
```

Notable defaults for new repositories:

- `has_wiki = false` (wiki disabled)
- `has_projects = false` (must set `true` if needed)
- `allow_merge_commit = false` (only squash merge allowed)
- `delete_branch_on_merge = true`
- `web_commit_signoff_required = true`
- `archive_on_destroy = true` (removing from config archives the repository, does not delete it)

## Step 4: New Team Access

If the repository needs a team that is not already in [`data.tf`](../data.tf), add a data source first:

```hcl
data "github_team" "new_team" {
  slug = "new-team-slug"
}
```

Then reference it in the repository config:

```hcl
access = {
  admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id]
  pushers = [data.github_team.new_team.id]
}
```

## What Gets Created Automatically

For each repository added, the module creates:

- The repository with all settings applied
- A branch protection ruleset on the default branch (signed commits, code owner reviews, stale review dismissal, linear history)
- Dependabot security updates enabled
- Team access (admin and push)
- Security and analysis settings (secret scanning, push protection)
- Default topics: `ministryofjustice`, `container-platform`

## Important: Add to App Scope First

Before merging the PR, add the new repository to the GitHub App's installation scope:

1. Go to [container-platform-github-access > Settings > GitHub Apps](https://github.com/ministryofjustice/container-platform-github-access/settings/installations)
2. Click Configure on "Container Platform Access" and authenticate
3. Under "Repository access", add the new repository
4. Then merge the Terraform PR

If you skip this step, the apply will fail with a 403 error.

**Last reviewed:** 26 May 2026
