variable "handle" {
  type = string
}

variable "handle_prefix" {
  type    = string
  default = "cloud-platform"
}

variable "use_handle_prefix" {
  type    = bool
  default = true
}

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

variable "users" {
  type = list(string)
}
