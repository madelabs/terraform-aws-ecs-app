##### ECS MODULE VARIABLES START #####

### GLOBAL ###
variable "project_name" {
  type        = string
  description = "The name of the project, this will affect log group names and service name."
  default     = "api-ecs-east-lab"
}

variable "environment" {
  type        = string
  description = "The specific environment or stage that applies to this project."
  default     = "east"
}

variable "region" {
  type        = string
  description = "The AWS region that the app definition will read from, make sure this matches with the provider used for this module."
  default     = "us-east-1"
}

variable "app_port" {
  type        = number
  description = "The port exposed on the container."
  default     = 80
}

variable "app_protocol" {
  type        = string
  description = "The protocol of the port exposed on the container."
  default     = "HTTP"
}

### LOAD BALANCER ###
variable "lb_type" {
  type        = string
  description = "The type of load balancer to create. Possible values are application, gateway, or network. The default value is application"
  default     = "application"
}

variable "lb_internal" {
  type        = bool
  description = "If true, the LB will be internal."
  default     = true
}

variable "lb_target_group_target_type" {
  type        = string
  description = "Type of target that you must specify when registering targets with this target group. [instance, ip, lambda, alb]"
  default     = "ip"
}

variable "lb_listener_action_type" {
  type        = string
  description = "Type of routing action. Valid values are [forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc]"
  default     = "forward"
}

variable "lb_target_group_health_check_healthy_threshold" {
  type        = number
  description = "Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3."
  default     = 3
}

variable "lb_target_group_health_check_interval" {
  type        = number
  description = "Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 30."
  default     = 30
}

variable "lb_target_group_health_check_matcher" {
  type        = number
  description = "Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, `200,202` for HTTP(s) or `0,12` for GRPC) or a range of values (for example, `200-299` or `0-99`). Required for HTTP/HTTPS/GRPC ALB."
  default     = 200
}

variable "lb_target_group_health_check_timeout" {
  type        = number
  description = "Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. "
  default     = 15
}

variable "lb_target_group_health_check_path" {
  type        = string
  description = "Destination for the health check request."
  default     = "/health"
}

variable "lb_target_group_health_check_unhealthy_threshold" {
  type        = number
  description = "Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3."
  default     = 3
}

### CLOUDWATCH ###
variable "log_group_retention_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 30
}

variable "log_stream_prefix" {
  type        = string
  description = "Use the awslogs-stream-prefix option to associate a log stream with the specified prefix, the container name, and the ID of the Amazon ECS task that the container belongs to. "
  default     = "ecs"
}

### IAM ###
variable "task_policy_actions" {
  type        = set(string)
  description = "List of services and their permissions to apply to the policy."
  default = [
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

variable "task_policy_resources" {
  type        = set(string)
  description = "Resources that task_policy_actions should be applied to."
  default     = ["*"]
}

### ECS SERVICE ###
variable "ecs_svc_container_desired_count" {
  type        = number
  description = "Number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the DAEMON scheduling strategy"
  default     = 1
}

variable "ecs_svc_deployment_maximum_percent" {
  type        = number
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Not valid when using the DAEMON scheduling strategy."
  default     = 200
}

variable "ecs_svc_deployment_minimum_healthy_percent" {
  type        = number
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 50
}

variable "ecs_svc_managed_tags" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service."
  default     = false
}

variable "ecs_svc_health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  default     = 30
}

variable "ecs_svc_launch_type" {
  type        = string
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL"
  default     = "FARGATE"
}

### ECS TASK ###
variable "ecs_task_cpu" {
  type        = number
  description = "Instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "ecs_task_memory" {
  type        = number
  description = "Amount (in MiB) of memory used by the task."
  default     = 2048
}

variable "ecs_task_network_mode" {
  type        = string
  description = "Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host."
  default     = "awsvpc"
}

variable "container_image_uri" {
  type        = string
  description = "Docker image to run in the ECS cluster"
  default     = "171549778621.dkr.ecr.us-east-1.amazonaws.com/ecs-api-lab:onlysecretscurl"
}

variable "container_essential" {
  type        = bool
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped. If the essential parameter of a container is marked as false, then its failure doesn't affect the rest of the containers in a task. If this parameter is omitted, a container is assumed to be essential. All tasks must have at least one essential container. If you have an application that's composed of multiple containers, group containers that are used for a common purpose into components, and separate the different components into multiple task definitions."
  default     = true
}

variable "container_task_definition_protocol" {
  type        = string
  description = "The protocol that's used for the port mapping. Valid values are tcp and udp. The default is tcp."
  default     = "tcp"
}

variable "container_health_check_retries" {
  type        = number
  description = "The number of times to retry a failed health check before the container is considered unhealthy. You may specify between 1 and 10 retries."
  default     = 3
}

variable "container_health_check_command" {
  type        = set(string)
  description = "A string array representing the command that the container runs to determine if it's healthy. The string array can start with CMD to run the command arguments directly, or CMD-SHELL to run the command with the container's default shell. If neither is specified, CMD is used. An exit code of 0, with no stderr output, indicates success, and a non-zero exit code indicates failure."
  default     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
}

variable "container_health_check_timeout" {
  type        = number
  description = "The period of time (in seconds) to wait for a health check to succeed before it's considered a failure. You may specify between 2 and 60 seconds. The default value is 5 seconds."
  default     = 5
}

variable "container_health_check_interval" {
  type        = number
  description = "The period of time (in seconds) between each health check. You may specify between 5 and 300 seconds. The default value is 10 seconds."
  default     = 10
}

variable "container_health_check_start_period" {
  type        = number
  description = "The optional grace period to provide containers time to bootstrap in before failed health checks count towards the maximum number of retries. You can specify between 0 and 300 seconds. By default, startPeriod is disabled."
  default     = 30
}

### SECURITY GROUPS ###

##### ECS MODULE VARIABLES END #####


##### CLUSTER MODULE VARIABLES START ###
variable "ecs_cluster_name" {
  type        = string
  description = "Name to give the cluster."
  default     = "ecs-east-lab-1"
}
##### CLUSTER MODULE VARIABLES END #####

##### VPC MODULE VARIABLES START #####
variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
  default     = "vpc-east-lab"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "vpc_enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = true
}

variable "vpc_number_of_private_subnets" {
  type        = number
  description = "Number of private subnets to provision."
  default     = 2
}

variable "vpc_private_subnet_cidr_blocks" {
  type        = list(string)
  description = ""
  default     = ["10.0.100.0/24", "10.0.200.0/24"]
}

variable "vpc_private_availability_zones" {
  type        = list(string)
  description = ""
  default     = ["us-east-1a", "us-east-1b"]
}

##### VPC MODULE VARIABLES END #####
