terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # cloudflare = {
    #   source  = "cloudflare/cloudflare"
    #   version = "~> 4.0"
    # }
  }

  # Configuring a remote backend
  backend "s3" {
    bucket = ""
    region = ""
    key    = ""
  }
}

provider "aws" {
  region = var.aws_region
}

# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }
