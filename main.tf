provider "aws" {
  region = "us-east-1"
  profile = "terraform-iac"
}

terraform {

  backend "s3" {
    bucket = "iac-urbanfood-tfstates"
    key    = "terraform.tfstate"
    region = "us-east-1"
    profile = "terraform-iac"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.90.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }

  required_version = "~> 1.11"
}
