# container-platform-github-access

Terraform-managed GitHub repository configuration for the Container Platform team.

## Repos to Manage

- Cilium
- Gatekeeper
- User Guide
- Template
- container-platform-github-access (this repo, self-managing)

## Implementation Plan

### 1. Identify repos to manage

Done. See list above.

### 2. Create repo from template

Create `container-platform-github-access` from `ministryofjustice/container-platform-terraform-template`.

Note: the template is designed for reusable modules, not root configs. We will need to add provider config, backend blocks, and state management on top of the scaffolding.

### 3. Decide on auth mechanism

Start with a fine-grained PAT scoped to the five repos listed above. This is a pragmatic short-term choice to unblock testing and validation.

Permissions required on the PAT:
- Administration (read/write)
- Metadata (read)
- Contents (read/write) -- needed for branch protection/rulesets

Store as a repo secret (`GITHUB_ACCESS_TOKEN` or similar).

**Follow-up ticket**: migrate from PAT to a GitHub App owned by the ministryofjustice org. This removes the dependency on any single individual and improves audit trail and security (short-lived installation tokens). Do not leave this as silent tech debt -- raise it as a ticket once the PAT-based setup is validated.

### 4. Customise template

Adapt the template files:
- `versions.tf` -- add `github` provider, set required Terraform version
- `main.tf` -- provider config using `var.github_token` and `var.github_owner`
- `locals.tf` -- map of repos with settings (description, visibility, topics, branch protection flags)
- `repos.tf` -- `github_repository` resources using `for_each` over locals
- `branch-protection.tf` -- `github_repository_ruleset` resources
- `variables.tf` -- `github_token` (sensitive), `github_owner`
- `backend.tf` -- S3 remote state config

### 5. Setup remote state

S3 backend with state locking. Determine which AWS account hosts the state bucket. Config goes in `backend.tf`.

### 6. Import existing repos

Script the imports rather than running them manually. For each repo:

```
terraform import 'github_repository.managed["repo-name"]' repo-name
```

Plus imports for any branch protection rulesets already in place.

### 7. Setup CI (GitHub Actions)

- On PR: `terraform fmt -check`, `terraform validate`, `terraform plan`
- On merge to main: `terraform apply -auto-approve`

PAT stored as repo secret and passed to the workflow as an environment variable.

### 8. Validation / tests

- `terraform fmt -check` -- formatting
- `terraform validate` -- syntax and config correctness
- `terraform plan` -- dry-run gate on PRs, catches drift and errors

More sophisticated testing (Terratest etc.) can be added later if needed.

### 9. Expand incrementally

Once the above is confirmed working with the five repos, add more repos and settings as needed. This is the scaffolding -- build on top of it.

## For Consideration

- Which AWS account holds the state bucket? This will be using one of the new CP AWS accounts.
