# Import blocks for existing resources
# These can be removed after the first successful apply

import {
  to = module.github_repositories["container-platform-github-access"].github_repository.this
  id = "container-platform-github-access"
}

import {
  to = module.github_repositories["container-platform-github-access"].github_repository_dependabot_security_updates.this
  id = "container-platform-github-access"
}

import {
  to = module.github_repositories["container-platform-github-access"].github_team_repository.admin["12737405"]
  id = "12737405:container-platform-github-access"
}

import {
  to = module.github_repositories["container-platform-github-access"].github_team_repository.pushers["4336307"]
  id = "4336307:container-platform-github-access"
}
