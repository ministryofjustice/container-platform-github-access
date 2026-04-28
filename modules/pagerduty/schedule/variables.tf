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

variable "team" {
  type        = string
  description = "Team owner of the schedule"
}

variable "time_zone" {
  type        = string
  description = "Time zone of the schedule"
  default     = "Europe/London"
}

variable "layers" {
  type = list(object({
    name                         = string
    start                        = string
    rotation_virtual_start       = string
    rotation_turn_length_seconds = number
    restrictions = optional(list(object({
      type              = string
      start_time_of_day = string
      duration_seconds  = number
      start_day_of_week = optional(string)
    })))
  }))
}

variable "users" {
  type = list(object({
    name      = string
    pagerduty = string
  }))
  description = "List of users with their PagerDuty identifiers"
  default     = []
}
