resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.project_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
