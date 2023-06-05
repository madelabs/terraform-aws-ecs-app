resource "aws_iam_role" "task_role" {
  name                 = "${var.project_name}-${var.environment}-task-role"
  assume_role_policy   = data.aws_iam_policy_document.task_role_trust_relationship_policy_document.json
  permissions_boundary = var.permissions_boundary == "" ? null : var.permissions_boundary
}

data "aws_iam_policy_document" "task_role_trust_relationship_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "task_policy" {
  name   = "${var.project_name}-${var.environment}-task-policy"
  policy = data.aws_iam_policy_document.task_policy_document.json
}

data "aws_iam_policy_document" "task_policy_document" {
  statement {
    actions   = var.task_policy_actions
    resources = var.task_policy_resources
  }
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role       = aws_iam_role.task_role.id
  policy_arn = aws_iam_policy.task_policy.arn
}

resource "aws_iam_policy" "ssm_task_policy" {
  name   = "${var.project_name}-${var.environment}-ssm-task-policy"
  policy = data.aws_iam_policy_document.ssm_task_policy_document.json
}

data "aws_iam_policy_document" "ssm_task_policy_document" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ssm_task_policy_attachment" {
  for_each   = var.ecs_svc_enable_ssm ? { SSM = "" } : {}
  role       = aws_iam_role.task_role.id
  policy_arn = aws_iam_policy.ssm_task_policy.arn
}

resource "aws_iam_role" "execution_role" {
  name                 = "${var.project_name}-${var.environment}-execution-role"
  assume_role_policy   = data.aws_iam_policy_document.execution_role_trust_relationship_policy_document.json
  permissions_boundary = var.permissions_boundary == "" ? null : var.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "execution_role_ecs_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "execution_role_secrets_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy_document" "execution_role_trust_relationship_policy_document" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
