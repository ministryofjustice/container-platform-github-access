### LOCALS

locals {
  # Predefined status check configurations
  status_check_configs = {
    codeql-analysis-actions = {
      context        = "CodeQL Analysis / CodeQL Analysis (actions)"
      integration_id = "15368"
    }
    codeql-analysis-python = {
      context        = "CodeQL Analysis / CodeQL Analysis (python)"
      integration_id = "15368"
    }
    dependency-review = {
      context        = "Dependency Review / Dependency Review"
      integration_id = "15368"
    }
    spell-check = {
      context        = "Spell Check / Spell Check"
      integration_id = "15368"
    }
    super-linter = {
      context        = "Super Linter / Super Linter"
      integration_id = "15368"
    }
    zizmor = {
      context        = "Zizmor / Zizmor"
      integration_id = "15368"
    }
  }

  # Default checks always enabled
  default_status_checks = [
    "codeql-analysis-actions",
    "dependency-review",
    "spell-check",
    "super-linter",
    "zizmor"
  ]

  # Combine defaults + additional predefined checks
  all_predefined_check_names = distinct(concat(
    local.default_status_checks,
    var.repository_ruleset_required_status_checks.additional_predefined_checks
  ))

  # Map predefined check names to their configs
  predefined_checks_map = {
    for check in local.all_predefined_check_names :
    check => local.status_check_configs[check]
    if contains(keys(local.status_check_configs), check)
  }

  # Merge predefined and custom checks
  enabled_status_checks = merge(
    local.predefined_checks_map,
    var.repository_ruleset_required_status_checks.custom_checks
  )

  # Map of code scanning tool names to their configuration
  code_scanning_configs = {
    codeql = {
      tool                      = "CodeQL"
      alerts_threshold          = "errors"
      security_alerts_threshold = "high_or_higher"
    }
    zizmor = {
      tool                      = "zizmor"
      alerts_threshold          = "errors"
      security_alerts_threshold = "high_or_higher"
    }
  }

  # Filter requested code scanning tools that exist in the config map
  enabled_code_scanning_tools = {
    for tool in var.repository_ruleset_required_code_scanning :
    tool => local.code_scanning_configs[tool]
    if contains(keys(local.code_scanning_configs), tool)
  }
}

### MAIN

#tfsec:ignore:AVD-GIT-0001:Ministry of Justice follow GOV.UK Service Manual guidance on coding in the open (https://www.gov.uk/service-manual/technology/making-source-code-open-and-reusable)
resource "github_repository" "this" {
  #checkov:skip=CKV_GIT_1:Ministry of Justice follow GOV.UK Service Manual guidance on coding in the open (https://www.gov.uk/service-manual/technology/making-source-code-open-and-reusable)

  name        = var.name
  description = var.description
  topics      = var.topics
  visibility  = var.visibility

  archived           = var.archived
  archive_on_destroy = var.archive_on_destroy

  is_template = var.is_template

  dynamic "template" {
    for_each = var.use_template ? [1] : []
    content {
      owner      = var.template_repository_owner
      repository = var.template_repository
    }
  }

  has_discussions             = var.has_discussions
  has_issues                  = var.has_issues
  has_projects                = var.has_projects
  has_wiki                    = var.has_wiki
  homepage_url                = var.homepage_url
  vulnerability_alerts        = var.vulnerability_alerts
  web_commit_signoff_required = var.web_commit_signoff_required

  auto_init = var.auto_init

  allow_merge_commit   = var.allow_merge_commit
  merge_commit_title   = var.merge_commit_title
  merge_commit_message = var.merge_commit_message

  allow_squash_merge          = var.allow_squash_merge
  squash_merge_commit_title   = var.squash_merge_commit_title
  squash_merge_commit_message = var.squash_merge_commit_message

  allow_update_branch    = var.allow_update_branch
  allow_auto_merge       = var.allow_auto_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  dynamic "pages" {
    for_each = var.pages_enabled ? [1] : []
    content {
      build_type = "workflow"
      cname      = var.pages_configuration.cname
    }
  }

  security_and_analysis {
    /*
      As per https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#advanced_security-1
      "If a repository's visibility is public, advanced security is always enabled and cannot be changed, so this setting cannot be supplied."
    */
    dynamic "advanced_security" {
      for_each = var.visibility == "private" || var.visibility == "internal" ? [1] : []
      content {
        status = var.advanced_security_status
      }
    }

    secret_scanning {
      status = var.secret_scanning_status
    }

    secret_scanning_push_protection {
      status = var.secret_scanning_push_protection_status
    }
  }
}

### RULESET

resource "github_repository_ruleset" "main" {
  name        = "main"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion                = var.repository_ruleset_deletion
    non_fast_forward        = var.repository_ruleset_non_fast_forward
    required_signatures     = var.repository_ruleset_required_signatures
    required_linear_history = var.repository_ruleset_required_linear_history

    pull_request {
      required_approving_review_count   = var.repository_ruleset_required_approving_review_count
      dismiss_stale_reviews_on_push     = var.repository_ruleset_dismiss_stale_reviews_on_push
      require_code_owner_review         = var.repository_ruleset_require_code_owner_review
      require_last_push_approval        = var.repository_ruleset_require_last_push_approval
      required_review_thread_resolution = var.repository_ruleset_required_review_thread_resolution
      allowed_merge_methods             = var.repository_ruleset_allowed_merge_methods
    }

    copilot_code_review {
      review_on_push             = var.copilot_code_review_review_on_push
      review_draft_pull_requests = var.copilot_code_review_review_draft_pull_requests
    }

    dynamic "required_status_checks" {
      for_each = length(local.enabled_status_checks) > 0 ? [1] : []
      content {
        do_not_enforce_on_create             = var.required_status_checks_do_not_enforce_on_create
        strict_required_status_checks_policy = var.required_status_checks_strict_required_status_checks_policy
        dynamic "required_check" {
          for_each = local.enabled_status_checks
          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }

    dynamic "required_code_scanning" {
      for_each = length(local.enabled_code_scanning_tools) > 0 ? [1] : []
      content {
        dynamic "required_code_scanning_tool" {
          for_each = local.enabled_code_scanning_tools
          content {
            tool                      = required_code_scanning_tool.value.tool
            alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
            security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
          }
        }
      }
    }
  }
}

### DEPENDABOT

resource "github_repository_dependabot_security_updates" "this" {
  repository = github_repository.this.id

  enabled = var.dependabot_security_updates_enabled
}

### ACCESS

resource "github_team_repository" "admin" {
  for_each = var.access != null && var.access.admins != null ? { for team in var.access.admins : team => team } : {}

  team_id    = each.value
  repository = github_repository.this.name
  permission = "admin"
}

resource "github_team_repository" "pushers" {
  for_each = var.access != null && var.access.pushers != null ? { for team in var.access.pushers : team => team } : {}

  team_id    = each.value
  repository = github_repository.this.name
  permission = "push"
}
