terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.90.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }    
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  #profile = "terraform-iac"
}

terraform {
  backend "s3" {
    bucket = "iac-urbanfood-tfstates"
    key    = "terraform.tfstate"
    region = "us-east-1"
    #profile = "terraform-iac"
  }
}

# doc: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest#before-you-use-this-resource