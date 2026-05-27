locals {
  github_repositories = {
    container_platform_github_access = {
      name         = "container-platform-github-access"
      description  = "Container Platform GitHub Access"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_documentation = {
      name        = "container-platform-documentation"
      description = "Container Platform Documentation created as part of AWS engagement"
      visibility  = "internal"
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id]
        pushers = [data.github_team.container_platform_aws.id]
      }
    }
    container_platform_terraform_gatekeeper = {
      name         = "container-platform-terraform-gatekeeper"
      description  = "Gatekeeper Terraform module for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_cilium = {
      name         = "container-platform-terraform-cilium"
      description  = "Cilium Terraform module for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_template = {
      name         = "container-platform-terraform-template"
      description  = "Template repository for Container Platform terraform modules"
      is_template  = true
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_external_dns = {
      name         = "container-platform-terraform-external-dns"
      description  = "External DNS Terraform module for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_karpenter = {
      name         = "container-platform-terraform-karpenter"
      description  = "Karpenter terraform deployment for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_user_guide = {
      name          = "container-platform-user-guide"
      description   = "User documentation for the Container Platform at the Ministry of Justice"
      has_projects  = true
      pages_enabled = true
      pages_configuration = {
        cname = "user-guide.development.container-platform.service.justice.gov.uk"
      }
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.webops.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
  }
}

module "github_repositories" {
  for_each = { for repository in local.github_repositories : repository.name => repository }

  source = "./modules/github/repository"

  name                = each.value.name
  description         = each.value.description
  visibility          = try(each.value.visibility, "public")
  is_template         = try(each.value.is_template, false)
  has_projects        = try(each.value.has_projects, false)
  has_discussions     = try(each.value.has_discussions, false)
  pages_enabled       = try(each.value.pages_enabled, false)
  pages_configuration = try(each.value.pages_configuration, null)
  topics              = try(each.value.topics, null)
  use_template        = try(each.value.use_template, false)
  access              = each.value.access
}
