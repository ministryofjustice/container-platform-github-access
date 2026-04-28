module "github_team" {
  source = "./modules/github/team"

  name            = "Data Platform"
  use_name_prefix = false
  parent_team_id  = data.github_team.octo_data_architecture.id
  members = distinct(flatten([
    for team_name, team in local.teams : [
      for user in team.members : user.github
    ] if team.github.enabled
  ]))
}

module "github_teams" {
  for_each = { for key, team in local.teams : key => team if team.github.enabled }

  source = "./modules/github/team"

  name           = each.value.name
  parent_team_id = module.github_team.id
  members        = [for user in each.value.members : user.github]
}
