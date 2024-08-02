# Variables
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnets_cidr" {}
variable "private_subnets_cidr" {}
variable "ap_availability_zone" {}

# outputs
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnets.*.cidr_block
}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "IGW_public_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  
  tags = {
    Name = "Internet Gateway for Public Subnets"
  }
}

# Setup Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  // Internet Traffic
    gateway_id = aws_internet_gateway.IGW_public_subnets.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "public-rt-subnets-association" {
  count = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Setup Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Private Route Table"
  }
}

# Private Route Table and Private Subnet Association
resource "aws_route_table_association" "private-rt-subnets-association" {
  count = length(aws_subnet.private_subnets)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
