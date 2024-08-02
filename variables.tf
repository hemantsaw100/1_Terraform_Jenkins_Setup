variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "Terraform Jenkins VPC"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "ap_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "public_key" {
  type        = string
  description = "EC2 Jenkins public key"
}