variable "name" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "Data Platform"
}

variable "use_name_prefix" {
  type    = bool
  default = true
}

variable "description" {
  type    = string
  default = "Managed in Terraform - https://github.com/ministryofjustice/cloud-platform-github-access"
}

variable "parent" {
  type    = string
  default = null
}

variable "managers" {
  type = list(object({
    name      = string
    pagerduty = string
  }))
  default = []
}

variable "responders" {
  type = list(object({
    name      = string
    pagerduty = string
  }))
  default = []
}
