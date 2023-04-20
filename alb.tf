resource "aws_lb" "ecs_alb" {
  load_balancer_type = var.lb_type
  internal           = var.lb_internal
  subnets            = aws_subnet.private_subnet.*.id # this needs to be converted to a variable with the value coming from the output of the VPC module.
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "ecs_alb_tg" {
  port        = var.app_port
  protocol    = var.app_protocol
  target_type = var.lb_target_group_target_type
  vpc_id      = aws_vpc.custom_vpc.id # this needs to be converted to a variable with the value coming from the output of the VPC module.

  health_check {
    healthy_threshold   = var.lb_target_group_health_check_healthy_threshold
    interval            = var.lb_target_group_health_check_interval
    protocol            = var.app_protocol
    matcher             = var.lb_target_group_health_check_matcher
    timeout             = var.lb_target_group_health_check_timeout
    path                = var.lb_target_group_health_check_path
    unhealthy_threshold = var.lb_target_group_health_check_unhealthy_threshold
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = var.app_port
  protocol          = var.app_protocol
  default_action {
    type             = var.lb_listener_action_type
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }
}
