module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  ap_availability_zone = var.ap_availability_zone
}

module "security_groups" {
  source              = "./security_groups"
  vpc_id              = module.networking.vpc_id
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "ec2-jenkins" {
  source                    = "./ec2-jenkins"
  instance_type             = "t2.micro"
  sg_for_jenkins            = [module.security_groups.sg_ec2_sg_ssh_http, module.security_groups.sg_ec2_jenkins_port_8080]
  subnet_id                 = tolist(module.networking.public_subnets)[0]
  public_key                = var.public_key
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./jenkins-runner-script/jenkins-installer.sh", {})
  # templatefile() function is used to read a file and render its contents, optionally using a set of variables to substitute placeholders within the file.
  # {} is a map of variables that can be passed into the template to replace placeholders. In this case, an empty map {} is used, which means no variables are being substituted in the script.
}

module "load-balancer-target-group" {
  source                   = "./load-balancer-target-group"
  vpc_id                   = module.networking.vpc_id
  lb_target_group_name     = "jenkins-lb-target-group"
  ec2_instance_id          = module.ec2-jenkins.jenkins_ec2_instance_id
  lb_target_group_port     = 8080
  lb_target_group_protocol = "HTTP"
}

module "application-load-balancer" {
  source = "./load-balancer"
  lb_name = "alb"
  lb_internal = "false"
  lb_type = "application"
  lb_security_groups = [module.security_groups.sg_ec2_sg_ssh_http]
  lb_subnets = tolist(module.networking.public_subnets)
  lb_target_group_arn = module.load-balancer-target-group.lb_target_group_arn
  lb_target_group_attachment_port = 8080
  ec2_instance_id = module.ec2-jenkins.jenkins_ec2_instance_id
  listener_port = 80
  lb_listner_protocol = "HTTP"
  listener_default_action = "forward"
  listener_target_group_arn = module.load-balancer-target-group.lb_target_group_arn
}