# Required Terraform version
# Only tested with v0.14.4
terraform {
  required_version = ">= 0.14.4"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Test VPC"
  }
}
