resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-load-balancer-security-group"
  description = "ALB Security Group for ${var.project_name}-${var.environment}-service"
  vpc_id      = local.actual_alb_vpc_id

  ingress {
    description = "Allow traffic from the internet on ${var.alb_ingress_port}"
    protocol    = "tcp"
    from_port   = var.alb_ingress_port
    to_port     = var.alb_ingress_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-${var.environment}-ecs-tasks-security-group"
  description = "ECS Security Group for ${var.project_name}-${var.environment}-service"
  vpc_id      = var.ecs_vpc_id

  ingress {
    description     = "Allow traffic from the ALB"
    protocol        = "tcp"
    from_port       = var.host_port
    to_port         = var.host_port
    security_groups = var.alb_vpc_id == "" ? [aws_security_group.alb.id] : null
    cidr_blocks     = var.alb_vpc_id != "" ? values(data.aws_subnet.alb_subnets).*.cidr_block : null
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "alb_subnets" {
  for_each = toset(var.alb_subnets)
  id       = each.value
}
