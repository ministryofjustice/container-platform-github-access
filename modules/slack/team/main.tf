locals {
  handle = var.use_handle_prefix ? "${var.handle_prefix}-${var.handle}-team" : var.handle
  name   = var.use_name_prefix ? "${var.name_prefix} ${var.name} Team" : var.name
}

resource "slack_usergroup" "this" {
  handle      = local.handle
  name        = local.name
  description = "${local.name} (managed in Terraform - https://github.com/ministryofjustice/cloud-platform-github-access)"
  users       = var.users
}
