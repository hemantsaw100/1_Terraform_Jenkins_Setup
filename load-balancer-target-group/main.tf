variable vpc_id {}
variable lb_target_group_name {}
variable lb_target_group_port {}
variable "lb_target_group_protocol" {}
variable ec2_instance_id {}

output "lb_target_group_arn" {
    value = aws_lb_target_group.lb_target_group.arn
}

resource "aws_lb_target_group" "lb_target_group" {
    name        = var.lb_target_group_name
    port        = var.lb_target_group_port
    protocol    = var.lb_target_group_protocol
    vpc_id      = var.vpc_id

    health_check{
        path = "/login"
        port = 8080
        protocol = "HTTP"
        timeout = 2
        interval = 5
        healthy_threshold = 6
        unhealthy_threshold = 2
        matcher = "200" # Has to be HTTP 200 or fails.  
    }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    target_id = var.ec2_instance_id
    port = 8080
    depends_on = [aws_lb_target_group.lb_target_group]
}