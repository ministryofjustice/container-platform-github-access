locals {
  name = var.use_name_prefix ? "${var.name_prefix} ${var.name}" : var.name
}

resource "pagerduty_team" "this" {
  name        = local.name
  description = var.description
  parent      = var.parent
}

resource "pagerduty_team_membership" "managers" {
  for_each = { for manager in var.managers : manager.name => manager.pagerduty }

  team_id = pagerduty_team.this.id
  user_id = each.value
  role    = "manager"
}

resource "pagerduty_team_membership" "responders" {
  for_each = { for responder in var.responders : responder.name => responder.pagerduty }

  team_id = pagerduty_team.this.id
  user_id = each.value
  role    = "responder"
}
