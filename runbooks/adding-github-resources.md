# Runbook: Adding a New Repository

This runbook explains how to add:

- a new GitHub repository and grant team access

## What is configurable

### Repository behavior and access

- Repository catalogue and per-repository settings:
  - [github-repositories.tf](../github-repositories.tf)
- Full list of supported repository feature flags/defaults:
  - [modules/github/repository/variables.tf]
    (../modules/github/repository/variables.tf)
- Resource implementation details (rulesets, security, access bindings):
  - [modules/github/repository/main.tf](../modules/github/repository/main.tf)

## Add a new repository

Repositories are defined in `github-repositories.tf`
in `local.github_repositories`.

### 1. Add a repository entry

Add a new map entry under `local.github_repositories`.

Example:

```hcl
my_new_repository = {
  name         = "my-new-repository"
  description  = "Repository for ..."
  topics       = ["ministryofjustice", "cloud-platform"]
  has_projects = true
  visibility   = "private"
  access = {
    admins  = [module.github_teams["cloud-platform-engineers"].id]
    pushers  = [module.github_teams["cloud-platform-engineers"].id]

  }
}
```

Common options already used in this repository:

- `visibility` (`public` or `private`)
- `has_discussions`
- `pages_enabled`
- `pages_configuration = { cname = "..." }`

### 2. Reference the correct team keys

Use the generated team key in access blocks, for example:

- `module.github_teams["cloud-platform"].id`

If access should be organization-wide, existing code uses:

- `data.github_team.all_org_members.id`

## Terraform checks

terraform init
terraform validate
terraform plan

## Open a PR

1. Commit changes with a clear message.
2. Open a PR describing:
   - team(s) added/changed
   - users added/changed
   - repository access model (admin/push teams)
3. Include the relevant `terraform plan` output in the PR description.

## Troubleshooting

- Schema enum failure for team names:
  - Update both `schema/teams.json` and `schema/users.json` enums.
- Team appears with no members:
  - Check user `teams` values match the generated team key exactly.
- GitHub repository access not applied:
  - Check `access` keys reference valid `module.octo_github_teams[...]` entries.