terraform {
  backend "s3" {
    bucket         = "cloud-platform-terraform-state"
    region         = "eu-west-1"
    key            = "container-platform-github-access/terraform.tfstate"
    dynamodb_table = "cloud-platform-terraform-state"
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.11.1"
    }
  }
  required_version = "~> 1.5"
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}
