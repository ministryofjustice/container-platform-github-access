variable "github_token" {
  description = "GitHub authentication token"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  type        = map(string)
  default = {
    business-unit = "Platforms"
    application   = "container-platform-github-access"
    is-production = "true"
    owner         = "Container Platform: platforms@digital.justice.gov.uk"
    source-code   = "github.com/ministryofjustice/container-platform-github-access"
    service-area  = "Hosting"
  }
}

variable "github_owner" {
  description = "GitHub organisation that owns the repos"
  type        = string
  default     = "ministryofjustice"
}
