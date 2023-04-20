# this resource should be broken out into its own module
resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_service" "service" {
  name                               = "${var.project_name}-svc"
  cluster                            = aws_ecs_cluster.cluster.id # this needs to be converted to a variable with the value coming from the ecs cluster module.
  task_definition                    = aws_ecs_task_definition.task.arn
  desired_count                      = var.ecs_svc_container_desired_count
  deployment_maximum_percent         = var.ecs_svc_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_svc_deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.ecs_svc_managed_tags
  health_check_grace_period_seconds  = var.ecs_svc_health_check_grace_period_seconds
  launch_type                        = var.ecs_svc_launch_type

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
    container_name   = var.project_name
    container_port   = var.app_port
  }

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = aws_subnet.private_subnet.*.id # this needs to be converted to a variable with the value coming from the output of the VPC module.
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-task"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  requires_compatibilities = [var.ecs_svc_launch_type]
  network_mode             = var.ecs_task_network_mode


  container_definitions = jsonencode([
    {
      name      = var.project_name
      image     = var.container_image_uri
      essential = var.container_essential

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.log_stream_prefix
        }
      }

      portMappings = [
        {
          "containerPort" = var.app_port
          "protocol"      = var.container_task_definition_protocol
          "hostPort"      = var.app_port
        }
      ],

      healthCheck = {
        "retries"     = var.container_health_check_retries
        "command"     = var.container_health_check_command
        "timeout"     = var.container_health_check_timeout
        "interval"    = var.container_health_check_interval
        "startPeriod" = var.container_health_check_start_period
      }
    }
  ])
}
