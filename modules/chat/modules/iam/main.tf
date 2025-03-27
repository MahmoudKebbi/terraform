# App Runner execution role
resource "aws_iam_role" "app_runner_execution_role" {
  name = "${var.name_prefix}-app-runner-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  tags = var.tags
}

# App Runner task role
resource "aws_iam_role" "app_runner_task_role" {
  name = "${var.name_prefix}-app-runner-task-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  tags = var.tags
}

# Permission for App Runner to access DynamoDB
resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.name_prefix}-dynamodb-access-policy"
  description = "Policy that allows access to DynamoDB"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          "arn:aws:dynamodb:*:*:table/*",
          "arn:aws:dynamodb:*:*:table/*/index/*"
        ]
      }
    ]
  })
  
  tags = var.tags
}

# Permission for App Runner to create log groups/streams
resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "${var.name_prefix}-cloudwatch-logs-policy"
  description = "Policy that allows writing to CloudWatch Logs"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
  
  tags = var.tags
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "task_dynamodb_access" {
  role       = aws_iam_role.app_runner_task_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_role_policy_attachment" "task_cloudwatch_access" {
  role       = aws_iam_role.app_runner_task_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}

resource "aws_iam_role_policy_attachment" "execution_ecr_access" {
  role       = aws_iam_role.app_runner_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}