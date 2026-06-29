locals {
  github_repositories = {
    container_platform_github_access = {
      name         = "container-platform-github-access"
      description  = "Container Platform GitHub Access"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_documentation = {
      name         = "container-platform-documentation"
      description  = "Container Platform Documentation created as part of AWS engagement"
      visibility   = "internal"
      use_template = false
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
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
      name                = "container-platform-terraform-cilium"
      description         = "Cilium Terraform module for the Container Platform"
      has_projects        = true
      template_repository = "cloud-platform-terraform-template"
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_template = {
      name                = "container-platform-terraform-template"
      description         = "Template repository for Container Platform terraform modules"
      is_template         = true
      has_projects        = true
      template_repository = "template-repository"
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_external_dns = {
      name         = "container-platform-terraform-external-dns"
      description  = "External DNS Terraform module for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_starter_pack = {
      name         = "container-platform-terraform-starter-pack"
      description  = "Starter pack Terraform module for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_karpenter = {
      name         = "container-platform-terraform-karpenter"
      description  = "Karpenter terraform deployment for the Container Platform"
      has_projects = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_user_guide = {
      name                = "container-platform-user-guide"
      description         = "User documentation for the Container Platform at the Ministry of Justice"
      has_projects        = true
      pages_enabled       = true
      template_repository = "template-documentation-site"
      pages_configuration = {
        cname = "user-guide.development.container-platform.service.justice.gov.uk"
      }
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_gateway_api = {
      name         = "container-platform-terraform-gateway-api"
      description  = "Gateway API Terraform module for the Container Platform"
      use_template = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_test_app = {
      name         = "container-platform-terraform-test-app"
      description  = "Test app Terraform module for the Container Platform"
      use_template = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container-platform-integration-tests = {
      name         = "container-platform-integration-tests"
      description  = "Integration tests for the Container Platform clusters"
      has_projects = true
      use_template = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_environments = {
      name                = "container-platform-environments"
      description         = "Container Platform environments repository"
      template_repository = "template-repository"
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
        pushers = [data.github_team.all_org_members.id]
      }
    }
    container_platform_terraform_cert_manager = {
      name         = "container-platform-terraform-cert-manager"
      description  = "Cert Manager Terraform module for the Container Platform"
      use_template = true
      access = {
        admins  = [module.github_team.id, data.github_team.cloud_platform_engineers.id, data.github_team.cloud_platform.id]
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
  use_template        = try(each.value.use_template, true)
  access              = each.value.access
  template_repository = try(each.value.template_repository, "container-platform-terraform-template")
}
