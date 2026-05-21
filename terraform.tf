terraform {
  backend "s3" {
    bucket       = "cloud-platform-terraform-state"
    region       = "eu-west-1"
    key          = "container-platform-github-access/terraform.tfstate"
    use_lockfile = true
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.11.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.10"
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = var.tags
  }
}
