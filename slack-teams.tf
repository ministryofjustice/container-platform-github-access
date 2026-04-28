module "slack_teams" {
  for_each = { for key, team in local.teams : key => team if team.slack.enabled }

  source = "./modules/slack/team"

  handle = each.key
  name   = each.value.name
  users  = [for user in each.value.members : user.slack]
}
