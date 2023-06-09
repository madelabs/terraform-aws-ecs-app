resource "aws_ecs_service" "service" {
  name                              = "${var.project_name}-${var.environment}-service"
  cluster                           = var.ecs_cluster_arn
  task_definition                   = aws_ecs_task_definition.task.arn
  health_check_grace_period_seconds = var.ecs_svc_health_check_grace_period_seconds
  desired_count                     = var.ecs_svc_container_desired_count
  launch_type                       = var.ecs_svc_launch_type
  platform_version                  = var.ecs_svc_fargate_platform_version
  enable_execute_command            = var.ecs_svc_enable_ssm

  network_configuration {
    assign_public_ip = var.public_ip
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.ecs_svc_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_name   = var.project_name
    container_port   = var.host_port
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-${var.environment}-task"
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
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = var.log_stream_prefix
        }
      }

      environment = var.container_environment_variables

      portMappings = [
        {
          "containerPort" = var.container_port
          "protocol"      = var.container_task_definition_protocol
          "hostPort"      = var.host_port
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
