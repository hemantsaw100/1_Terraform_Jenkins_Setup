
# networking
output "vpc_id" {
  value = module.networking.vpc_id
}

# ec2-jenkins
output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i C:/Users/hesaw/Downloads/Jenkins_ssh_keys/jenkins_ec2 ubuntu@", module.ec2-jenkins.jenkins_ec2_instance_public_ip)
}

output "jenkins_ec2_instance_id" {
  value = module.ec2-jenkins.jenkins_ec2_instance_id
}

output "jenkins_ec2_instance_public_ip" {
  value = "${module.ec2-jenkins.jenkins_ec2_instance_public_ip}:8080"
}
  