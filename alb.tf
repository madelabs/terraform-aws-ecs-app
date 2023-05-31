resource "aws_alb" "alb" {
  name            = "${var.project_name}-${var.environment}-alb"
  internal        = var.alb_internal
  subnets         = var.alb_subnets
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.project_name}-${var.environment}"
  port        = var.host_port
  protocol    = var.host_protocol
  vpc_id      = var.vpc_id
  target_type = var.alb_target_group_target_type

  health_check {
    healthy_threshold   = var.alb_target_group_health_check_healthy_threshold
    interval            = var.alb_target_group_health_check_interval
    protocol            = var.host_protocol
    matcher             = var.alb_target_group_health_check_matcher
    timeout             = var.alb_target_group_health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.alb_target_group_health_check_unhealthy_threshold
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.alb_ingress_port
  protocol          = "HTTPS"
  ssl_policy        = var.alb_listener_ssl_policy
  certificate_arn   = var.alb_listener_certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = var.alb_listener_action_type
  }
}
