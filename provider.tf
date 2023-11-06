terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.acm]
    }

    github = {
      source  = "integrations/github"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region     = "eu-central-1"
  access_key = ""
  secret_key = ""
}

provider "aws" {
  alias   = "acm"
  region  = "us-east-1"
}

provider "github" {
  token = var.github_token
}