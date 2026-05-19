module "github_team" {
  source = "./modules/github/team"

  name           = "Container Platform"
  description    = "Container Platform (Managed in Terraform - https://github.com/ministryofjustice/container-platform-github-access)"
  parent_team_id = data.github_team.octo_hosting.id
}
