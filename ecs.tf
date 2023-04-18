resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.container_definition.rendered
}

resource "aws_ecs_service" "service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.container_count
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = var.public_ip
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.id
    container_name   = var.project_name
    container_port   = var.container_port
  }
}


data "template_file" "container_definition" {
  template = file("${path.module}/templates/app.tpl")

  vars = {
    container_image = "${var.container_image_uri}"
    container_port  = var.container_port
    fargate_cpu     = var.fargate_cpu
    fargate_memory  = var.fargate_memory
    aws_region      = var.aws_region
    project_name    = var.project_name
    container_name  = var.project_name
    log_group       = aws_cloudwatch_log_group.log_group.name
  }
}
