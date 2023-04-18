variable "project_name" {
  type        = string
  description = "Project name for the ECS task and service."
}

variable "aws_region" {
  type        = string
  description = "The AWS region that the app definition will read from, make sure this matches with the provider used for this module."
}

variable "container_image_uri" {
  type        = string
  description = "Docker image to run in the ECS cluster"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "container_count" {
  type        = number
  description = "Number of docker containers to run"
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  type        = number
  description = "Fargate instance memory to provision (in MiB)"
}

variable "health_check_path" {
  type        = string
  description = "Destination for the health check request."
}

variable "public_ip" {
  type        = bool
  description = "whether or not to assign a public IP"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to create resources in."
}

variable "private_subnets" {
  type        = set(string)
  description = "Private subnets in which to run the service (task cluster)."
}

variable "public_subnets" {
  type        = set(string)
  description = "Public subnets in which to run the ALB."
}
