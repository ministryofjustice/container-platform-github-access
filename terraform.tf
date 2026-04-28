terraform {
  backend "s3" {
    bucket       = "mojdp-development-iac"
    region       = "eu-west-2"
    encrypt      = true
    kms_key_id   = "arn:aws:kms:eu-west-2:013433889002:key/0bd77db7-700e-41d0-b33a-8a689ecde25e"
    use_lockfile = true
    key          = "cloud-platform-github-access/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.40.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.8.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.11.1"
    }
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "3.32.1"
    }
    slack = {
      source  = "figma/slack"
      version = "1.3.2"
    }
  }
  required_version = "~> 1.5"
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = var.tags
  }
}

provider "azuread" {
  client_id     = jsondecode(data.aws_secretsmanager_secret_version.entra_credentials.secret_string)["client_id"]
  client_secret = jsondecode(data.aws_secretsmanager_secret_version.entra_credentials.secret_string)["client_secret"]
  tenant_id     = jsondecode(data.aws_secretsmanager_secret_version.entra_credentials.secret_string)["tenant_id"]
}

provider "github" {
  owner = "ministryofjustice"
  app_auth {
    id              = jsondecode(data.aws_secretsmanager_secret_version.github_app.secret_string)["app_id"]
    installation_id = jsondecode(data.aws_secretsmanager_secret_version.github_app.secret_string)["installation_id"]
    pem_file        = base64decode(jsondecode(data.aws_secretsmanager_secret_version.github_app.secret_string)["private_key"])
  }
}

provider "pagerduty" {
  token = data.aws_secretsmanager_secret_version.pagerduty_api_key.secret_string
}

provider "slack" {
  token = data.aws_secretsmanager_secret_version.slack_token.secret_string
}
