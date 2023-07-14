resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = var.log_group_retention_days
}

resource "aws_cloudwatch_event_rule" "ecs_deployment" {
  count = var.ecs_svc_enable_deployment_event_alerts ? 1 : 0
  name  = "${var.project_name}-${var.environment}-ecs-deployment-events"
  event_pattern = jsonencode({
    "source"      = ["aws.ecs"],
    "detail-type" = ["ECS Deployment State Change"],

    "detail" = {
      "eventName" = var.ecs_svc_deployment_events
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_deployment_events_sns" {
  count     = var.ecs_svc_enable_deployment_event_alerts ? 1 : 0
  rule      = aws_cloudwatch_event_rule.ecs_deployment[0].name
  target_id = "${var.project_name}-${var.environment}-ecs-deployment-events"
  arn       = aws_sns_topic.ecs_deployment_events[0].arn
}

resource "aws_sns_topic" "ecs_deployment_events" {
  count = var.ecs_svc_enable_deployment_event_alerts ? 1 : 0
  name  = "${var.project_name}-${var.environment}-ecs-deployment-events"
}

resource "aws_sns_topic_policy" "ecs_deployment_events_policy" {
  count  = var.ecs_svc_enable_deployment_event_alerts ? 1 : 0
  arn    = aws_sns_topic.ecs_deployment_events[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy[0].json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count = var.ecs_svc_enable_deployment_event_alerts ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.ecs_deployment_events[0].arn]
  }
}

resource "aws_sns_topic_subscription" "ecs_deployment_events_sns_subscription" {
  count     = var.ecs_svc_enable_deployment_event_alerts ? 1 : 0
  topic_arn = aws_sns_topic.ecs_deployment_events[0].arn
  protocol  = var.sns_topic_subscription_protocol
  endpoint  = var.sns_topic_subscription_endpoint
}
