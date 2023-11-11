# Configuring terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# AWS provider configured using AWS CLI credentials files
provider "aws" {
  region = "us-east-1"
}