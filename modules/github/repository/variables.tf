### MAIN

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "topics" {
  type = list(string)
  default = [
    "ministryofjustice", "container-platform"
  ]
}

variable "visibility" {
  type    = string
  default = "public"
}

variable "archived" {
  type    = bool
  default = false
}

variable "archive_on_destroy" {
  type    = bool
  default = true
}

variable "is_template" {
  type    = bool
  default = false
}

variable "use_template" {
  type    = bool
  default = true
}

variable "template_repository_owner" {
  type    = string
  default = "ministryofjustice"
}

variable "template_repository" {
  type    = string
  default = "template-repository"
}

variable "has_discussions" {
  type    = bool
  default = false
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_projects" {
  type    = bool
  default = false
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "homepage_url" {
  type    = string
  default = null
}

variable "vulnerability_alerts" {
  type    = bool
  default = true
}

variable "web_commit_signoff_required" {
  type    = bool
  default = true
}

variable "auto_init" {
  type    = bool
  default = true
}

variable "allow_merge_commit" {
  type    = bool
  default = false
}

variable "merge_commit_title" {
  type    = string
  default = "MERGE_MESSAGE"
}

variable "merge_commit_message" {
  type    = string
  default = "PR_TITLE"
}

variable "allow_squash_merge" {
  type    = bool
  default = true
}

variable "squash_merge_commit_title" {
  type    = string
  default = "PR_TITLE"
}

variable "squash_merge_commit_message" {
  type    = string
  default = "COMMIT_MESSAGES"
}

variable "allow_update_branch" {
  type    = bool
  default = true
}

variable "allow_auto_merge" {
  type    = bool
  default = false
}

variable "allow_rebase_merge" {
  type    = bool
  default = false
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "pages_enabled" {
  type    = bool
  default = false
}

variable "pages_configuration" {
  type = object({
    cname = string
  })
  default = null
}

variable "advanced_security_status" {
  type    = string
  default = "enabled"
}

variable "secret_scanning_status" {
  type    = string
  default = "enabled"
}

variable "secret_scanning_push_protection_status" {
  type    = string
  default = "enabled"
}

### RULESET

variable "repository_ruleset_deletion" {
  type    = bool
  default = true
}

variable "repository_ruleset_non_fast_forward" {
  type    = bool
  default = true
}

variable "repository_ruleset_required_signatures" {
  type    = bool
  default = true
}

variable "repository_ruleset_required_linear_history" {
  type    = bool
  default = true
}

variable "repository_ruleset_required_approving_review_count" {
  type    = number
  default = 1
}

variable "repository_ruleset_dismiss_stale_reviews_on_push" {
  type    = bool
  default = true
}

variable "repository_ruleset_require_code_owner_review" {
  type    = bool
  default = true
}

variable "repository_ruleset_require_last_push_approval" {
  type    = bool
  default = true
}

variable "repository_ruleset_required_review_thread_resolution" {
  type    = bool
  default = true
}

variable "repository_ruleset_allowed_merge_methods" {
  type    = list(string)
  default = ["squash"]
}

### DEPENDABOT

variable "dependabot_security_updates_enabled" {
  type    = bool
  default = true
}

### ACCESS

variable "access" {
  type = object({
    admins      = optional(list(string))
    maintainers = optional(list(string))
    pushers     = optional(list(string))
  })
  default = {
    admins      = []
    maintainers = []
    pushers     = []
  }
}
