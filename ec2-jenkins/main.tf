# Variables
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_for_jenkins" {}
variable "enable_public_ip_address" {}
variable public_key {}
variable "user_data_install_jenkins" {}

# Outputs
output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i C:/Users/hesaw/Downloads/Jenkins_ssh_keys/jenkins_ec2 ubuntu@", aws_instance.jenkins-ec2.public_ip)
}

output "jenkins_ec2_instance_id" {
  value = aws_instance.jenkins-ec2.id
}

output "jenkins_ec2_instance_public_ip" {
  value = aws_instance.jenkins-ec2.public_ip
}

# Use data block to fetch latest Ubuntu Linux AMI Id
data "aws_ami" "ec2_ami" {
    most_recent = true

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240701.1"] # AMI Name (Ubuntu Server 24.04 LTS)
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
}

resource "aws_instance" "jenkins-ec2" {
    instance_type = var.instance_type
    ami = data.aws_ami.ec2_ami.id
    vpc_security_group_ids = var.sg_for_jenkins
    subnet_id = var.subnet_id
    associate_public_ip_address = var.enable_public_ip_address
    key_name = "jenkins_ec2"
    user_data = var.user_data_install_jenkins

  # The metadata_options block in Terraform allows you to configure important security settings for the AWS EC2 Instance Metadata Service. By enabling the endpoint and requiring IMDSv2 tokens, you enhance the security of your instances against unauthorized metadata access. This is a recommended best practice, especially for applications that are publicly accessible or where enhanced security is a priority.
  metadata_options { 
    http_endpoint = "enabled"  # Enable the IMDSv2 (Instance Metadata Service version 2) endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }

    tags = {
      "Name" = "Jenkins Ubuntu Linux EC2 Instance"
    }
}

resource "aws_key_pair" "jenkins_ec2_key_pair" {
  key_name = "jenkins_ec2"
  public_key = var.public_key
}