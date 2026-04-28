locals {
  name_upper = var.name
  name       = var.use_name_prefix ? "${var.name_prefix} ${local.name_upper}" : local.name_upper
}

resource "github_team" "this" {
  name           = local.name
  description    = var.description
  privacy        = var.privacy
  parent_team_id = try(var.parent_team_id, null)
}

resource "github_team_membership" "this" {
  for_each = toset(var.members)

  team_id  = github_team.this.id
  username = each.value
  role     = "member"

  lifecycle {
    ignore_changes = [role]
  }
}
