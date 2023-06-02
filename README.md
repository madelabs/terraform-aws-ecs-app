# terraform-aws-ecs-app

A Terraform module for managing a multi-AZ ECS application.

<!-- BEGIN MadeLabs Header -->
![MadeLabs is for hire!](https://d2xqy67kmqxrk1.cloudfront.net/horizontal_logo_white.png)
MadeLabs is proud to support the open source community with these blueprints for provisioning infrastructure to help software builders get started quickly and with confidence. 

We're also for hire: [https://www.madelabs.io](https://www.madelabs.io)

<!-- END MadeLabs Header -->

<!-- BEGIN_TF_DOCS -->
## Requirements

- VPC with subnets
- URI to a container hosted in an accessible registry
- ACM certificate for the application load balancer

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.execution_role_ecs_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.execution_role_secrets_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.execution_role_trust_relationship_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_role_trust_relationship_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ingress_port"></a> [alb\_ingress\_port](#input\_alb\_ingress\_port) | Port for which the ALB listens on to accept traffic and route to the target group. | `number` | `443` | no |
| <a name="input_alb_internal"></a> [alb\_internal](#input\_alb\_internal) | Whether or not the loab balancer is internal. | `bool` | `false` | no |
| <a name="input_alb_listener_action_type"></a> [alb\_listener\_action\_type](#input\_alb\_listener\_action\_type) | Type of routing action. Valid values are [forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc] | `string` | `"forward"` | no |
| <a name="input_alb_listener_certificate_arn"></a> [alb\_listener\_certificate\_arn](#input\_alb\_listener\_certificate\_arn) | ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS. | `string` | n/a | yes |
| <a name="input_alb_listener_ssl_policy"></a> [alb\_listener\_ssl\_policy](#input\_alb\_listener\_ssl\_policy) | Name of the SSL Policy for the listener. | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_alb_stickiness_enabled"></a> [alb\_stickiness\_enabled](#input\_alb\_stickiness\_enabled) | Whether or not stickiness is enabled on the ALB. | `bool` | `true` | no |
| <a name="input_alb_subnets"></a> [alb\_subnets](#input\_alb\_subnets) | Subnets in which to run the ALB. | `set(string)` | n/a | yes |
| <a name="input_alb_target_group_health_check_healthy_threshold"></a> [alb\_target\_group\_health\_check\_healthy\_threshold](#input\_alb\_target\_group\_health\_check\_healthy\_threshold) | Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3. | `number` | `3` | no |
| <a name="input_alb_target_group_health_check_interval"></a> [alb\_target\_group\_health\_check\_interval](#input\_alb\_target\_group\_health\_check\_interval) | Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 30. | `number` | `30` | no |
| <a name="input_alb_target_group_health_check_matcher"></a> [alb\_target\_group\_health\_check\_matcher](#input\_alb\_target\_group\_health\_check\_matcher) | Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, `200,202` for HTTP(s) or `0,12` for GRPC) or a range of values (for example, `200-299` or `0-99`). Required for HTTP/HTTPS/GRPC ALB. | `number` | `200` | no |
| <a name="input_alb_target_group_health_check_timeout"></a> [alb\_target\_group\_health\_check\_timeout](#input\_alb\_target\_group\_health\_check\_timeout) | Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. | `number` | `15` | no |
| <a name="input_alb_target_group_health_check_unhealthy_threshold"></a> [alb\_target\_group\_health\_check\_unhealthy\_threshold](#input\_alb\_target\_group\_health\_check\_unhealthy\_threshold) | Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3. | `number` | `3` | no |
| <a name="input_alb_target_group_target_type"></a> [alb\_target\_group\_target\_type](#input\_alb\_target\_group\_target\_type) | Type of target that you must specify when registering targets with this target group. [instance, ip, lambda, alb] | `string` | `"ip"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region that the app definition will read from, make sure this matches with the provider used for this module. | `string` | `"us-east-2"` | no |
| <a name="input_container_essential"></a> [container\_essential](#input\_container\_essential) | If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped. If the essential parameter of a container is marked as false, then its failure doesn't affect the rest of the containers in a task. If this parameter is omitted, a container is assumed to be essential. All tasks must have at least one essential container. If you have an application that's composed of multiple containers, group containers that are used for a common purpose into components, and separate the different components into multiple task definitions. | `bool` | `true` | no |
| <a name="input_container_health_check_command"></a> [container\_health\_check\_command](#input\_container\_health\_check\_command) | A string array representing the command that the container runs to determine if it's healthy. The string array can start with CMD to run the command arguments directly, or CMD-SHELL to run the command with the container's default shell. If neither is specified, CMD is used. An exit code of 0, with no stderr output, indicates success, and a non-zero exit code indicates failure. | `set(string)` | n/a | yes |
| <a name="input_container_health_check_interval"></a> [container\_health\_check\_interval](#input\_container\_health\_check\_interval) | The period of time (in seconds) between each health check. You may specify between 5 and 300 seconds. The default value is 10 seconds. | `number` | `10` | no |
| <a name="input_container_health_check_retries"></a> [container\_health\_check\_retries](#input\_container\_health\_check\_retries) | The number of times to retry a failed health check before the container is considered unhealthy. You may specify between 1 and 10 retries. | `number` | `3` | no |
| <a name="input_container_health_check_start_period"></a> [container\_health\_check\_start\_period](#input\_container\_health\_check\_start\_period) | The optional grace period to provide containers time to bootstrap in before failed health checks count towards the maximum number of retries. You can specify between 0 and 300 seconds. By default, startPeriod is disabled. | `number` | `30` | no |
| <a name="input_container_health_check_timeout"></a> [container\_health\_check\_timeout](#input\_container\_health\_check\_timeout) | The period of time (in seconds) to wait for a health check to succeed before it's considered a failure. You may specify between 2 and 60 seconds. The default value is 5 seconds. | `number` | `5` | no |
| <a name="input_container_image_uri"></a> [container\_image\_uri](#input\_container\_image\_uri) | Docker image to run in the ECS cluster | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | For task definitions that use the awsvpc network mode, only specify the containerPort. The hostPort can be left blank or it must be the same value as the containerPort. | `number` | n/a | yes |
| <a name="input_container_task_definition_protocol"></a> [container\_task\_definition\_protocol](#input\_container\_task\_definition\_protocol) | The protocol that's used for the port mapping. Valid values are tcp and udp. The default is tcp. | `string` | `"tcp"` | no |
| <a name="input_ecs_svc_container_desired_count"></a> [ecs\_svc\_container\_desired\_count](#input\_ecs\_svc\_container\_desired\_count) | Number of docker containers to run | `number` | `1` | no |
| <a name="input_ecs_svc_health_check_grace_period_seconds"></a> [ecs\_svc\_health\_check\_grace\_period\_seconds](#input\_ecs\_svc\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `30` | no |
| <a name="input_ecs_svc_launch_type"></a> [ecs\_svc\_launch\_type](#input\_ecs\_svc\_launch\_type) | Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL | `string` | `"FARGATE"` | no |
| <a name="input_ecs_svc_subnets"></a> [ecs\_svc\_subnets](#input\_ecs\_svc\_subnets) | Subnets in which to run the service (task cluster). | `set(string)` | n/a | yes |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | n/a | yes |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | Fargate instance memory to provision (in MiB) | `number` | n/a | yes |
| <a name="input_ecs_task_network_mode"></a> [ecs\_task\_network\_mode](#input\_ecs\_task\_network\_mode) | Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host. | `string` | `"awsvpc"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The specific environment or stage that applies to this project. [example dev, uat, prod] | `string` | n/a | yes |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Destination for the health check request. | `string` | n/a | yes |
| <a name="input_host_port"></a> [host\_port](#input\_host\_port) | The port exposed on the container. | `number` | n/a | yes |
| <a name="input_host_protocol"></a> [host\_protocol](#input\_host\_protocol) | The protocol of the port exposed on the container. | `string` | n/a | yes |
| <a name="input_log_group_retention_days"></a> [log\_group\_retention\_days](#input\_log\_group\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_log_stream_prefix"></a> [log\_stream\_prefix](#input\_log\_stream\_prefix) | Use the awslogs-stream-prefix option to associate a log stream with the specified prefix, the container name, and the ID of the Amazon ECS task that the container belongs to. | `string` | `"ecs"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name for the ECS task and service. | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | whether or not to assign a public IP | `bool` | `false` | no |
| <a name="input_task_policy_actions"></a> [task\_policy\_actions](#input\_task\_policy\_actions) | List of services and their permissions to apply to the policy. | `set(string)` | n/a | yes |
| <a name="input_task_policy_resources"></a> [task\_policy\_resources](#input\_task\_policy\_resources) | Resources that task\_policy\_actions should be applied to. | `set(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create resources in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_hostname"></a> [alb\_hostname](#output\_alb\_hostname) | n/a |
| <a name="output_ecs_tasks_security_group_id"></a> [ecs\_tasks\_security\_group\_id](#output\_ecs\_tasks\_security\_group\_id) | n/a |
