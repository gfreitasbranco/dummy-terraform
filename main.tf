# Required Terraform version
# Only tested with v0.14.4
terraform {
  required_version = ">= 0.14.4"
}

provider "aws" {
  region = "us-west-2"
}

# AMI
data "aws_ami" "aws-linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

####
# INSTANCES
resource "aws_instance" "linux1" {
  ami = data.aws_ami.aws-linux.id
  instance_type = "t2.micro"
  subnet_id = "subnet-0adba1ecf2f2867e7"
  vpc_security_group_ids = ["sg-0faa58047af970f59"]
  tags = {
    Name = "Test Linux Gabriel"
  }
}
