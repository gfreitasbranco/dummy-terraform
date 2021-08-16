# Required Terraform version
# Only tested with v0.14.4
terraform {
  required_version = ">= 0.14.4"
}

provider "aws" {
  region = "eu-west-1"
}

# Map available AZs
data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.network_address_space
  enable_dns_hostnames = "true"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet1" {
  cidr_block = cidrsubnet(var.network_address_space, 4, 0)
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[0]
}

# ROUTING
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

#####
# Security group to control what get insides the EC2 instances
resource "aws_security_group" "test_security_group" {
  name_prefix = "Test Security Group"
  description = "Security group for testing"
  vpc_id      = aws_vpc.vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "Test Security Group"
  }
}

resource "aws_security_group_rule" "allow_ssh_inbound_from_cidr_blocks" {
  count       = length(var.allowed_cidr_blocks) >= 1 ? 1 : 0
  type        = "ingress"
  from_port   = var.ssh_port
  to_port     = var.ssh_port
  protocol    = "tcp"
  cidr_blocks = var.allowed_cidr_blocks

  security_group_id = aws_security_group.test_security_group.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.test_security_group.id
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
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = aws_security_group.test_security_group.id
  key_name = var.ssh_key_name
  tags = {
    Name = var.instance_name
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_path)
  }
}
