# these resources should be broken out into their own module
resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.vpc_number_of_private_subnets
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.vpc_private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.vpc_private_availability_zones, count.index)
}

resource "aws_route_table_association" "subnet_route_assoc" {
  count          = var.vpc_number_of_private_subnets
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_vpc.custom_vpc.default_route_table_id
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [aws_security_group.vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [aws_security_group.vpc_endpoint.id]

  tags = {
    Name        = "ECR API VPC Endpoint Interface - ${var.environment}"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.custom_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.custom_vpc.default_route_table_id]

  tags = {
    Name        = "S3 VPC Endpoint Gateway - ${var.environment}"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "aws_secret" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [aws_security_group.vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "aws_ecs" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [aws_security_group.vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "aws_cloudwatch" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [aws_security_group.vpc_endpoint.id]
}
