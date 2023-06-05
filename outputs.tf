output "alb_hostname" {
  value = aws_alb.alb.dns_name
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}
