variable "lb_name" {}
variable "lb_internal" {}
variable "lb_type" {}
variable "lb_security_groups" {}
variable "lb_subnets" {}
variable "lb_target_group_arn" {}
variable "lb_target_group_attachment_port" {}
variable "ec2_instance_id" {}
variable "listener_port" {}
variable "lb_listner_protocol" {}
variable "listener_default_action" {}
variable "listener_target_group_arn" {}


resource "aws_lb" "load_balancer" {
    name = var.lb_name
    internal = var.lb_internal
    load_balancer_type = var.lb_type
    security_groups = var.lb_security_groups
    subnets = var.lb_subnets

    tags = {
      Name = "Ec2 Instance Load Balancer"
    }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
    target_group_arn = var.lb_target_group_arn
    target_id = var.ec2_instance_id
    port = var.lb_target_group_attachment_port
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = var.listener_port
  protocol = var.lb_listner_protocol

  default_action {
    type = var.listener_default_action
    target_group_arn = var.listener_target_group_arn
  }
}