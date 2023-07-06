module "ecs_app" {
  source  = "madelabs/ecs-app/aws"
  version = "0.0.4"

  project_name = "my-project"
  environment  = "prod"
  aws_region   = "us-east-1"

  alb_listener_certificate_arn = "arn:aws:acm:us-east-1:1234567890123:certificate/123abcde-f345-6789-0123-9abcdefgh01"

  alb_internal = false
  alb_subnets  = ["subnet-2234567890123", "subnet-2234567890124"]
  public_ip    = true

  ecs_vpc_id                       = "vpc-1234567890123"
  ecs_cluster_arn                  = "arn:aws:ecs:us-east-1:1234567890123:cluster/my-cluster"
  ecs_svc_subnets                  = ["subnet-1234567890123", "subnet-1234567890124"]
  ecs_svc_container_desired_count  = 2
  ecs_task_cpu                     = 256
  ecs_task_memory                  = 512
  ecs_svc_enable_ssm               = true
  ecs_svc_fargate_platform_version = "LATEST"

  host_port           = 80
  container_port      = 80
  host_protocol       = "HTTP"
  container_image_uri = "1234567890123.dkr.ecr.us-east-1.amazonaws.com/myimage:latest"

  health_check_path              = "/health"
  container_health_check_command = ["CMD-SHELL", "curl -f http://localhost:80/health|| exit 1"]
  container_environment_variables = [
    {
      "name"  = "ASPNETCORE_ENVIRONMENT",
      "value" = "Development"
    }
  ]

  # It is recommended to tailor the policy to follow least privilege principles, the below is just an example. 
  task_policy_actions = [
    "s3:Get*",
    "s3:List*",
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "logs:CreateLogGroup",
    "secretsmanager:*",
    "logs:DescribeLogStreams"
  ]
}
