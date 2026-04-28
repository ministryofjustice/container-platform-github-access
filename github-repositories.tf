locals {
  github_repositories = {
    container_platform_github_access = {
      name         = "container-platform-github-access"
      description  = "Container Platform Github Access"
      visibility   = "public"
      has_projects = true
      access = {
        admins = [
          module.github_teams["cloud-platform"].id
        ]
        pushers = [data.github_team.all_org_members.id]
      }
    }

/*     container_platform_terraform_cilium = {
      name         = "container-platform-terraform-cilium"
      description  = "Terraform module that deploys and manages cilium service"
      visibility   = "public"
      has_projects = true
      access = {
        admins = [
          module.github_teams["cloud-platform"].id
        ]
        pushers = [data.github_team.all_org_members.id]
      }
    }

    container_platform_terraform_gatekeeper  = {
      name         = "container-platform-terraform-gatekeeper"
      description  = "Terraform module that deploys cloud-platform's OPA (Open Policy Agent) gatekeeper; supersedes https://github.com/ministryofjustice/cloud-platform-terraform-opa"
      visibility   = "public"
      has_projects = true
      access = {
        admins = [
          module.github_teams["cloud-platform"].id
        ]
        pushers = [data.github_team.all_org_members.id]
      }
    }

    container_platform_terraform_template  = {
      name         = "container-platform-terraform-template"
      description  = "Template repository for Container Platform terraform modules"
      visibility   = "public"
      has_projects = true
      access = {
        admins = [
          module.github_teams["cloud-platform"].id
        ]
        pushers = [data.github_team.all_org_members.id]
      }
    } */
  }
}

module "github_repositories" {
  for_each = { for repository in local.github_repositories : repository.name => repository }

  source = "./modules/github/repository"

  name                                      = each.value.name
  description                               = each.value.description
  visibility                                = try(each.value.visibility, "public")
  has_discussions                           = try(each.value.has_discussions, false)
  has_projects                              = try(each.value.has_projects, false)
  access                                    = each.value.access
  homepage_url                              = try(each.value.homepage_url, null)
  pages_enabled                             = try(each.value.pages_enabled, false)
  pages_configuration                       = try(each.value.pages_configuration, null)
  repository_ruleset_required_status_checks = try(each.value.repository_ruleset_required_status_checks, {})
}
