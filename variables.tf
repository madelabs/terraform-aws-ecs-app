variable "project_name" {
  type        = string
  description = "Project name for the ECS task and service."
}

variable "environment" {
  type        = string
  description = "The specific environment or stage that applies to this project. [example dev, uat, prod]"
}

variable "aws_region" {
  type        = string
  description = "The AWS region that the app definition will read from, make sure this matches with the provider used for this module."
}

variable "host_port" {
  type        = number
  description = "The port exposed on the container."
}

variable "host_protocol" {
  type        = string
  description = "The protocol of the port exposed on the container."
}

variable "health_check_path" {
  type        = string
  description = "Destination for the health check request."
}

variable "public_ip" {
  type        = bool
  description = "Whether or not to assign a public IP address."
  default     = false
}

### ECS ###
variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of the ECS cluster to create resources in."
}

variable "ecs_vpc_id" {
  type        = string
  description = "The ID of the VPC to create ECS resources in."
}

variable "ecs_svc_subnets" {
  type        = set(string)
  description = "Subnets in which to run the service (task cluster)."
}

variable "ecs_svc_launch_type" {
  type        = string
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL"
  default     = "FARGATE"
}

variable "ecs_svc_fargate_platform_version" {
  type        = string
  description = "Platform version on which to run your service. Only applicable for launch_type set to FARGATE."
  default     = "LATEST"
}

variable "ecs_svc_container_desired_count" {
  type        = number
  description = "Number of docker containers to run"
  default     = 2
}

variable "ecs_svc_deployment_maximum_percent" {
  type        = number
  description = "Value representing the upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
  default     = 200
}

variable "ecs_svc_deployment_minimum_percent" {
  type        = number
  description = "Value representing the lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 100
}

variable "ecs_svc_force_new_deployment" {
  type        = string
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g., myimage:latest), roll Fargate tasks onto a newer platform version, or immediately deploy ordered_placement_strategy and placement_constraints updates."
  default     = false
}

variable "ecs_svc_capacity_provider_strategy" {
  type = list(object({
    capacity_provider = string
    base              = number
    weight            = number
  }))
  description = "Capacity provider strategies to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if force_new_deployment = true and not changing from 0 capacity_provider_strategy blocks to greater than 0, or vice versa."
  default     = []
}


variable "ecs_svc_enable_deployment_circuit_breaker" {
  type        = bool
  description = "Enable ECS deployment circuit breaker. This will enable ECS to roll back to the previous deployment if the new deployment fails."
  default     = true
}

variable "ecs_svc_health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  default     = 0
}

variable "ecs_svc_enable_ssm" {
  type        = bool
  description = "Enable SSM and Docker Exec capabilities to the ECS task. Setting this to true from false on an existing running service requires a new deployment."
  default     = false
}

variable "ecs_task_cpu" {
  type        = number
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "ecs_task_memory" {
  type        = number
  description = "Fargate instance memory to provision (in MiB)"
}

variable "ecs_task_network_mode" {
  type        = string
  description = "Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host."
  default     = "awsvpc"
}

variable "ecs_svc_enable_deployment_event_alerts" {
  type        = bool
  description = "To enable or disable cloudwatch rule and sns topic creation for ECS deployment events."
  default     = false
}

variable "ecs_svc_deployment_events" {
  type        = set(string)
  description = "List of ECS deployment events to send to the SNS topic."
  default     = ["SERVICE_DEPLOYMENT_FAILED"]
}

variable "container_image_uri" {
  type        = string
  description = "Docker image to run in the ECS cluster"
}

variable "container_essential" {
  type        = bool
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped. If the essential parameter of a container is marked as false, then its failure doesn't affect the rest of the containers in a task. If this parameter is omitted, a container is assumed to be essential. All tasks must have at least one essential container. If you have an application that's composed of multiple containers, group containers that are used for a common purpose into components, and separate the different components into multiple task definitions."
  default     = true
}

variable "container_port" {
  type        = number
  description = "For task definitions that use the awsvpc network mode, only specify the containerPort. The hostPort can be left blank or it must be the same value as the containerPort. "
}

variable "container_task_definition_protocol" {
  type        = string
  description = "The protocol that's used for the port mapping. Valid values are tcp and udp. The default is tcp."
  default     = "tcp"

  validation {
    condition     = can(regex("^(tcp|udp)$", var.container_task_definition_protocol))
    error_message = "Must be either tcp or udp"
  }
}

variable "container_environment_variables" {
  type = list(object({
    name  = string,
    value = string
  }))
  description = "The environment variables to pass to a container. This parameter maps to Env in the Create a container section of the Docker Remote API and the --env option to docker run."
  default     = []
}

variable "container_health_check_retries" {
  type        = number
  description = "The number of times to retry a failed health check before the container is considered unhealthy. You may specify between 1 and 10 retries."
  default     = 3
}

variable "container_health_check_command" {
  type        = set(string)
  description = "A string array representing the command that the container runs to determine if it's healthy. The string array can start with CMD to run the command arguments directly, or CMD-SHELL to run the command with the container's default shell. If neither is specified, CMD is used. An exit code of 0, with no stderr output, indicates success, and a non-zero exit code indicates failure."
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

### IAM ###
variable "permissions_boundary" {
  type        = string
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  default     = ""
}

variable "task_policy_actions" {
  type        = set(string)
  description = "List of services and their permissions to apply to the policy."
}

variable "task_policy_resources" {
  type        = set(string)
  description = "Resources that task_policy_actions should be applied to."
  default     = ["*"]
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

### SNS ###
variable "sns_topic_subscription_protocol" {
  type        = string
  description = "The protocol you want to use. Supported protocols include: [email, email-json, http, https, sqs, sms, lambda]"
  default     = "https"

  validation {
    condition     = can(regex("^(email|email-json|http|https|sqs|sms|lambda)$", var.sns_topic_subscription_protocol))
    error_message = "Must be either email, email-json, http, https, sqs, sms or lambda"
  }
}

variable "sns_topic_subscription_endpoint" {
  type        = string
  description = "The endpoint that you want to receive notifications."
  default     = ""
}

### LOAD BALANCER ###
variable "alb_internal" {
  type        = bool
  description = "Whether or not the loab balancer is internal."
  default     = false
}

variable "alb_vpc_id" {
  type        = string
  description = "The ID of ALB VPC to create ALB resources in. Defaults to the ID of ecs_vpc_id if none specified."
  default     = ""
}

variable "alb_subnets" {
  type        = set(string)
  description = "Subnets in which to run the ALB."
}

variable "alb_drop_invalid_header_fields" {
  type        = bool
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens."
  default     = true
}

variable "alb_ingress_port" {
  type        = number
  description = "Port for which the ALB listens on to accept traffic and route to the target group."
  default     = 443
}

variable "alb_target_group_target_type" {
  type        = string
  description = "Type of target that you must specify when registering targets with this target group. [instance, ip, lambda, alb]"
  default     = "ip"
}

variable "alb_target_group_deregistration_delay" {
  type        = number
  description = "Amount of time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  default     = 0
}

variable "alb_listener_action_type" {
  type        = string
  description = "Type of routing action. Valid values are [forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc]"
  default     = "forward"
}

variable "alb_listener_ssl_policy" {
  type        = string
  description = "Name of the SSL Policy for the listener."
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "alb_listener_certificate_arn" {
  type        = string
  description = "ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
}

variable "alb_target_group_health_check_healthy_threshold" {
  type        = number
  description = "Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3."
  default     = 3
}

variable "alb_target_group_health_check_interval" {
  type        = number
  description = "Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 30."
  default     = 30
}

variable "alb_target_group_health_check_matcher" {
  type        = number
  description = "Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, `200,202` for HTTP(s) or `0,12` for GRPC) or a range of values (for example, `200-299` or `0-99`). Required for HTTP/HTTPS/GRPC ALB."
  default     = 200
}

variable "alb_target_group_health_check_timeout" {
  type        = number
  description = "Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. "
  default     = 15
}

variable "alb_target_group_health_check_unhealthy_threshold" {
  type        = number
  description = "Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3."
  default     = 3
}

variable "alb_stickiness_enabled" {
  type        = bool
  description = "Whether or not stickiness is enabled on the ALB."
  default     = true
}

variable "alb_idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle."
  default     = 60
}
