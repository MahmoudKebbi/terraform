resource "aws_iam_role" "api_gateway_execute_role" {
  name = "api-gateway-execute-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "api_gateway_execute_policy" {
  name        = "api-gateway-execute-policy"
  description = "IAM policy for API Gateway to interact with ECS services"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "ecs:StopTask",
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTasks",
          "ecs:ListContainerInstances",
          "ecs:DescribeContainerInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_execute_attach" {
  role       = aws_iam_role.api_gateway_execute_role.name
  policy_arn = aws_iam_policy.api_gateway_execute_policy.arn
}

