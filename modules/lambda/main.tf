resource "aws_lambda_function" "user_functions" {
  for_each = toset(["create", "get", "update", "delete"])

  function_name = "user_${each.key}"
  role          = var.lambda_execution_role_arn
  handler       = "index.${each.key}_user"
  runtime       = "python3.9"

  filename         = "${path.module}/lambda_functions/user_${each.key}.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_functions/user_${each.key}.zip")

  environment {
    variables = {
      USERS_TABLE_NAME = var.users_table_name
    }
  }

  timeout     = 30
  memory_size = 128

  tags = var.tags
}

resource "aws_lambda_function" "transaction_functions" {
  for_each = toset(["record", "get", "update", "delete"])

  function_name = "transaction_${each.key}"
  role          = var.lambda_execution_role_arn
  handler       = "index.${each.key}_transaction"
  runtime       = "python3.9"

  filename         = "${path.module}/lambda_functions/transaction_${each.key}.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_functions/transaction_${each.key}.zip")

  environment {
    variables = {
      TRANSACTIONS_TABLE_NAME = var.transactions_table_name
    }
  }

  timeout     = 30
  memory_size = 128

  tags = var.tags
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  for_each = toset(["user_functions", "transaction_functions"])

  name       = "${each.key}_policy_attachment"
  roles      = [var.lambda_execution_role_name]
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBAccessPolicy"
  description = "IAM policy for allowing Lambda functions to access DynamoDB tables"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = [
          aws_dynamodb_table.users_table.arn,
          aws_dynamodb_table.transactions_table.arn
        ]
      }
    ]
  })
}