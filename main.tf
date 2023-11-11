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

# Example VPC and Subnet creation (if needed)
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Hello world
resource "aws_instance" "hello_world_instance" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id # Add this line to specify the subnet

  tags = {
    Name = "HelloWorldInstance"
  }
}