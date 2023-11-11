## VPC variables
variable "vpc-cidr-block" {
  type = string
}

variable "public-subnets-cidr-blocks" {
    type = list(string)
}

variable "private-subnets-cidr-blocks" {
    type = list(string)
}

variable "public-subnet-1-cidr-block" {
  type = string
}

variable "private-subnet-1-cidr-block" {
  type = string
}

variable "project" {
    type = string
}

variable "region" {
    type = string
} 
