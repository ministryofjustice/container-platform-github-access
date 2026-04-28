variable "name" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "Cloud Platform"
}

variable "use_name_prefix" {
  type    = bool
  default = true
}

variable "description" {
  type    = string
  default = "Managed in Terraform - https://github.com/ministryofjustice/cloud-platform-github-access"
}

variable "privacy" {
  type    = string
  default = "closed"
}

variable "parent_team_id" {
  type    = string
  default = null
}

variable "members" {
  type    = list(string)
  default = []
}
