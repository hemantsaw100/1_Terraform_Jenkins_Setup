# Variables
variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "ec2_jenkins_sg_name" {}

# Outputs
output "sg_ec2_sg_ssh_http" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "sg_ec2_jenkins_port_8080" {
  value = aws_security_group.ec2_jenkins_sg_port_8080.id
}

resource "aws_security_group" "ec2_sg_ssh_http" {
    name = var.ec2_sg_name
    description = "Enable the Port 22(SSH), Port 80(http) and Port 443(https)"
    vpc_id = var.vpc_id

    # ssh for terraform remote exec
    ingress {
        description = "Allow remote SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Enable HTTP
    ingress {
        description = "Allow HTTP request from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Enable HTTPS
    ingress {
        description = "Allow HTTPS request from anywhere"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #Outgoing request
    egress {
        description = "Allow outgoing request"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Security Group to allow SSH(22), HTTP(80) & HTTPS(443)"
    }
}

resource "aws_security_group" "ec2_jenkins_sg_port_8080" {
    name = var.ec2_jenkins_sg_name
    description = "Enable the Port 8080 for Jenkins"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow 8080 port to access jenkins"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Security Group to allow port 8080"
    }
}