locals {
  teams_config = yamldecode(file("${path.module}/configuration/teams.yaml"))
  users_config = yamldecode(file("${path.module}/configuration/users.yaml"))

  teams = {
    for team in local.teams_config : lower(replace(team.name, " ", "-")) => {
      name      = team.name
      members   = [for user in local.users_config : user if contains(user.teams, lower(replace(team.name, " ", "-")))]
      entra     = team.entra
      github    = team.github
      pagerduty = team.pagerduty
      slack     = team.slack
    }
  }
}
