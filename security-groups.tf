resource "aws_security_group" "lb" {
  description = "${var.project_name} Load Balancer Security Group"
  vpc_id      = aws_vpc.custom_vpc.id # this needs to be converted to a variable with the value coming from the output of the VPC module.

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["10.0.100.0/24", "10.0.200.0/24"]
  }
}

resource "aws_security_group" "ecs" {
  description = "${var.project_name} ECS Security Group"
  vpc_id      = aws_vpc.custom_vpc.id # this needs to be converted to a variable with the value coming from the output of the VPC module.

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# this security group should be grouped with the VPC resources and its module
resource "aws_security_group" "vpc_endpoint" {
  description = "${var.project_name} VPC Endpoint Security Group"
  vpc_id      = aws_vpc.custom_vpc.id # this needs to be converted to a variable with the value coming from the output of the VPC module.

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["10.0.100.0/24", "10.0.200.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
