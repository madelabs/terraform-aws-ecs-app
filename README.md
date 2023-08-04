# terraform-aws-ecs-app

<!-- BEGIN MadeLabs Header -->
![MadeLabs is for hire!](https://d2xqy67kmqxrk1.cloudfront.net/horizontal_logo_white.png)
MadeLabs is proud to support the open source community with these blueprints for provisioning infrastructure to help software builders get started quickly and with confidence. 

We're also for hire: [https://www.madelabs.io](https://www.madelabs.io)

<!-- END MadeLabs Header -->


---

A Terraform module for managing a multi-AZ ECS application.

![PlantUML model](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/madelabs/terraform-aws-ecs-app/main/docs/diagram.puml)

## Requirements

- VPC with subnets
- Existing ECS cluster
- URI to a container hosted in an accessible registry
- ACM certificate for the application load balancer

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_cloudwatch_event_rule.ecs_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ecs_deployment_events_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ssm_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.execution_role_ecs_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.execution_role_secrets_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_task_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.ecs_deployment_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.ecs_deployment_events_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.ecs_deployment_events_sns_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.execution_role_trust_relationship_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_task_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_role_trust_relationship_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.alb_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_drop_invalid_header_fields"></a> [alb\_drop\_invalid\_header\_fields](#input\_alb\_drop\_invalid\_header\_fields) | Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. | `bool` | `true` | no |
| <a name="input_alb_idle_timeout"></a> [alb\_idle\_timeout](#input\_alb\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_alb_ingress_port"></a> [alb\_ingress\_port](#input\_alb\_ingress\_port) | Port for which the ALB listens on to accept traffic and route to the target group. | `number` | `443` | no |
| <a name="input_alb_internal"></a> [alb\_internal](#input\_alb\_internal) | Whether or not the loab balancer is internal. | `bool` | `false` | no |
| <a name="input_alb_listener_action_type"></a> [alb\_listener\_action\_type](#input\_alb\_listener\_action\_type) | Type of routing action. Valid values are [forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc] | `string` | `"forward"` | no |
| <a name="input_alb_listener_certificate_arn"></a> [alb\_listener\_certificate\_arn](#input\_alb\_listener\_certificate\_arn) | ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS. | `string` | n/a | yes |
| <a name="input_alb_listener_ssl_policy"></a> [alb\_listener\_ssl\_policy](#input\_alb\_listener\_ssl\_policy) | Name of the SSL Policy for the listener. | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_alb_stickiness_enabled"></a> [alb\_stickiness\_enabled](#input\_alb\_stickiness\_enabled) | Whether or not stickiness is enabled on the ALB. | `bool` | `true` | no |
| <a name="input_alb_subnets"></a> [alb\_subnets](#input\_alb\_subnets) | Subnets in which to run the ALB. | `set(string)` | n/a | yes |
| <a name="input_alb_target_group_deregistration_delay"></a> [alb\_target\_group\_deregistration\_delay](#input\_alb\_target\_group\_deregistration\_delay) | Amount of time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds. | `number` | `0` | no |
| <a name="input_alb_target_group_health_check_healthy_threshold"></a> [alb\_target\_group\_health\_check\_healthy\_threshold](#input\_alb\_target\_group\_health\_check\_healthy\_threshold) | Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 2. | `number` | `2` | no |
| <a name="input_alb_target_group_health_check_interval"></a> [alb\_target\_group\_health\_check\_interval](#input\_alb\_target\_group\_health\_check\_interval) | Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 10. | `number` | `10` | no |
| <a name="input_alb_target_group_health_check_matcher"></a> [alb\_target\_group\_health\_check\_matcher](#input\_alb\_target\_group\_health\_check\_matcher) | Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, `200,202` for HTTP(s) or `0,12` for GRPC) or a range of values (for example, `200-299` or `0-99`). Required for HTTP/HTTPS/GRPC ALB. | `number` | `200` | no |
| <a name="input_alb_target_group_health_check_timeout"></a> [alb\_target\_group\_health\_check\_timeout](#input\_alb\_target\_group\_health\_check\_timeout) | Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. | `number` | `5` | no |
| <a name="input_alb_target_group_health_check_unhealthy_threshold"></a> [alb\_target\_group\_health\_check\_unhealthy\_threshold](#input\_alb\_target\_group\_health\_check\_unhealthy\_threshold) | Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 2. | `number` | `2` | no |
| <a name="input_alb_target_group_target_type"></a> [alb\_target\_group\_target\_type](#input\_alb\_target\_group\_target\_type) | Type of target that you must specify when registering targets with this target group. [instance, ip, lambda, alb] | `string` | `"ip"` | no |
| <a name="input_alb_vpc_id"></a> [alb\_vpc\_id](#input\_alb\_vpc\_id) | The ID of ALB VPC to create ALB resources in. Defaults to the ID of ecs\_vpc\_id if none specified. | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region that the app definition will read from, make sure this matches with the provider used for this module. | `string` | n/a | yes |
| <a name="input_container_environment_variables"></a> [container\_environment\_variables](#input\_container\_environment\_variables) | The environment variables to pass to a container. This parameter maps to Env in the Create a container section of the Docker Remote API and the --env option to docker run. | <pre>list(object({<br>    name  = string,<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_container_essential"></a> [container\_essential](#input\_container\_essential) | If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped. If the essential parameter of a container is marked as false, then its failure doesn't affect the rest of the containers in a task. If this parameter is omitted, a container is assumed to be essential. All tasks must have at least one essential container. If you have an application that's composed of multiple containers, group containers that are used for a common purpose into components, and separate the different components into multiple task definitions. | `bool` | `true` | no |
| <a name="input_container_health_check_command"></a> [container\_health\_check\_command](#input\_container\_health\_check\_command) | A string array representing the command that the container runs to determine if it's healthy. The string array can start with CMD to run the command arguments directly, or CMD-SHELL to run the command with the container's default shell. If neither is specified, CMD is used. An exit code of 0, with no stderr output, indicates success, and a non-zero exit code indicates failure. | `set(string)` | n/a | yes |
| <a name="input_container_health_check_interval"></a> [container\_health\_check\_interval](#input\_container\_health\_check\_interval) | The period of time (in seconds) between each health check. You may specify between 5 and 300 seconds. The default value is 5 seconds. | `number` | `5` | no |
| <a name="input_container_health_check_retries"></a> [container\_health\_check\_retries](#input\_container\_health\_check\_retries) | The number of times to retry a failed health check before the container is considered unhealthy. You may specify between 1 and 10 retries. | `number` | `2` | no |
| <a name="input_container_health_check_start_period"></a> [container\_health\_check\_start\_period](#input\_container\_health\_check\_start\_period) | The optional grace period to provide containers time to bootstrap in before failed health checks count towards the maximum number of retries. You can specify between 0 and 300 seconds. | `number` | `10` | no |
| <a name="input_container_health_check_timeout"></a> [container\_health\_check\_timeout](#input\_container\_health\_check\_timeout) | The period of time (in seconds) to wait for a health check to succeed before it's considered a failure. You may specify between 2 and 60 seconds. The default value is 3 seconds. | `number` | `3` | no |
| <a name="input_container_image_uri"></a> [container\_image\_uri](#input\_container\_image\_uri) | Docker image to run in the ECS cluster | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | For task definitions that use the awsvpc network mode, only specify the containerPort. The hostPort can be left blank or it must be the same value as the containerPort. | `number` | n/a | yes |
| <a name="input_container_task_definition_protocol"></a> [container\_task\_definition\_protocol](#input\_container\_task\_definition\_protocol) | The protocol that's used for the port mapping. Valid values are tcp and udp. The default is tcp. | `string` | `"tcp"` | no |
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | ARN of the ECS cluster to create resources in. | `string` | n/a | yes |
| <a name="input_ecs_svc_capacity_provider_strategy"></a> [ecs\_svc\_capacity\_provider\_strategy](#input\_ecs\_svc\_capacity\_provider\_strategy) | Capacity provider strategies to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if force\_new\_deployment = true and not changing from 0 capacity\_provider\_strategy blocks to greater than 0, or vice versa. | <pre>list(object({<br>    capacity_provider = string<br>    base              = number<br>    weight            = number<br>  }))</pre> | `[]` | no |
| <a name="input_ecs_svc_container_desired_count"></a> [ecs\_svc\_container\_desired\_count](#input\_ecs\_svc\_container\_desired\_count) | Number of docker containers to run | `number` | `2` | no |
| <a name="input_ecs_svc_deployment_events"></a> [ecs\_svc\_deployment\_events](#input\_ecs\_svc\_deployment\_events) | List of ECS deployment events to send to the SNS topic. | `set(string)` | <pre>[<br>  "SERVICE_DEPLOYMENT_FAILED"<br>]</pre> | no |
| <a name="input_ecs_svc_deployment_maximum_percent"></a> [ecs\_svc\_deployment\_maximum\_percent](#input\_ecs\_svc\_deployment\_maximum\_percent) | Value representing the upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. | `number` | `200` | no |
| <a name="input_ecs_svc_deployment_minimum_percent"></a> [ecs\_svc\_deployment\_minimum\_percent](#input\_ecs\_svc\_deployment\_minimum\_percent) | Value representing the lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment. | `number` | `100` | no |
| <a name="input_ecs_svc_enable_deployment_circuit_breaker"></a> [ecs\_svc\_enable\_deployment\_circuit\_breaker](#input\_ecs\_svc\_enable\_deployment\_circuit\_breaker) | Enable ECS deployment circuit breaker. This will enable ECS to roll back to the previous deployment if the new deployment fails. | `bool` | `true` | no |
| <a name="input_ecs_svc_enable_deployment_event_alerts"></a> [ecs\_svc\_enable\_deployment\_event\_alerts](#input\_ecs\_svc\_enable\_deployment\_event\_alerts) | To enable or disable cloudwatch rule and sns topic creation for ECS deployment events. | `bool` | `false` | no |
| <a name="input_ecs_svc_enable_ssm"></a> [ecs\_svc\_enable\_ssm](#input\_ecs\_svc\_enable\_ssm) | Enable SSM and Docker Exec capabilities to the ECS task. Setting this to true from false on an existing running service requires a new deployment. | `bool` | `false` | no |
| <a name="input_ecs_svc_fargate_platform_version"></a> [ecs\_svc\_fargate\_platform\_version](#input\_ecs\_svc\_fargate\_platform\_version) | Platform version on which to run your service. Only applicable for launch\_type set to FARGATE. | `string` | `"LATEST"` | no |
| <a name="input_ecs_svc_force_new_deployment"></a> [ecs\_svc\_force\_new\_deployment](#input\_ecs\_svc\_force\_new\_deployment) | Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g., myimage:latest), roll Fargate tasks onto a newer platform version, or immediately deploy ordered\_placement\_strategy and placement\_constraints updates. | `string` | `false` | no |
| <a name="input_ecs_svc_health_check_grace_period_seconds"></a> [ecs\_svc\_health\_check\_grace\_period\_seconds](#input\_ecs\_svc\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `5` | no |
| <a name="input_ecs_svc_launch_type"></a> [ecs\_svc\_launch\_type](#input\_ecs\_svc\_launch\_type) | Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL | `string` | `"FARGATE"` | no |
| <a name="input_ecs_svc_subnets"></a> [ecs\_svc\_subnets](#input\_ecs\_svc\_subnets) | Subnets in which to run the service (task cluster). | `set(string)` | n/a | yes |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | n/a | yes |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | Fargate instance memory to provision (in MiB) | `number` | n/a | yes |
| <a name="input_ecs_task_network_mode"></a> [ecs\_task\_network\_mode](#input\_ecs\_task\_network\_mode) | Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host. | `string` | `"awsvpc"` | no |
| <a name="input_ecs_vpc_id"></a> [ecs\_vpc\_id](#input\_ecs\_vpc\_id) | The ID of the VPC to create ECS resources in. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The specific environment or stage that applies to this project. [example dev, uat, prod] | `string` | n/a | yes |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Destination for the health check request. | `string` | n/a | yes |
| <a name="input_host_port"></a> [host\_port](#input\_host\_port) | The port exposed on the container. | `number` | n/a | yes |
| <a name="input_host_protocol"></a> [host\_protocol](#input\_host\_protocol) | The protocol of the port exposed on the container. | `string` | n/a | yes |
| <a name="input_log_group_retention_days"></a> [log\_group\_retention\_days](#input\_log\_group\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_log_stream_prefix"></a> [log\_stream\_prefix](#input\_log\_stream\_prefix) | Use the awslogs-stream-prefix option to associate a log stream with the specified prefix, the container name, and the ID of the Amazon ECS task that the container belongs to. | `string` | `"ecs"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name for the ECS task and service. | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Whether or not to assign a public IP address. | `bool` | `false` | no |
| <a name="input_sns_topic_subscription_endpoint"></a> [sns\_topic\_subscription\_endpoint](#input\_sns\_topic\_subscription\_endpoint) | The endpoint that you want to receive notifications. | `string` | `""` | no |
| <a name="input_sns_topic_subscription_protocol"></a> [sns\_topic\_subscription\_protocol](#input\_sns\_topic\_subscription\_protocol) | The protocol you want to use. Supported protocols include: [email, email-json, http, https, sqs, sms, lambda] | `string` | `"https"` | no |
| <a name="input_task_policy_actions"></a> [task\_policy\_actions](#input\_task\_policy\_actions) | List of services and their permissions to apply to the policy. | `set(string)` | n/a | yes |
| <a name="input_task_policy_resources"></a> [task\_policy\_resources](#input\_task\_policy\_resources) | Resources that task\_policy\_actions should be applied to. | `set(string)` | <pre>[<br>  "*"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_hostname"></a> [alb\_hostname](#output\_alb\_hostname) | n/a |
| <a name="output_ecs_tasks_security_group_id"></a> [ecs\_tasks\_security\_group\_id](#output\_ecs\_tasks\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->