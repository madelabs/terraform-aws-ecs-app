resource "aws_alb" "alb" {
  name            = "${var.project_name}-alb"
  internal        = var.alb_internal
  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.project_name}-target-group"
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.id
    type             = "forward"
  }
}
