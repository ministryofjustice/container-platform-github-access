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

variable "team" {
  type        = string
  description = "ID of the team to assign to this escalation policy"
}

variable "num_loops" {
  type        = number
  description = "Number of times to loop through the escalation targets"
}

variable "rules" {
  type = list(object({
    escalation_delay_in_minutes = number,
    targets = list(object({
      type = string,
      id   = string
    }))
  }))
  description = "List of rules to escalate to"
}
