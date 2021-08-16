variable "ssh_port" {
  description = "Port used by SSH service"
  default     = 22
}

variable "allowed_cidr_blocks" {
  description = "Alloowed IP ranges on Splunk connectivity rules"
}

variable "network_address_space" {
  description = "This is the VPC CIDR block"
  default     = "10.60.60.0/24"
}

variable "vpc_name" {
  description = "This is the VPC name, a default value will be provided but it can be overwritten"
  type        = string
  default     = "Test VPC"
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
  default     = "Test server"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for each node in the cluster (e.g. t2.micro)."
  type        = string
  default     = "t2.micro"
}

variable "ssh_key" {
  description = "This is the SSH public key that will be used for SSH access to the created instances"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key to be used, related to 'ssh_key'"
  type        = string
  default     = "deploy-key"
}

variable "private_key_path" {
  description = "Location of the private key on the local disk"
  type        = string
  default     = "~/.ssh/id_rsa"
}
