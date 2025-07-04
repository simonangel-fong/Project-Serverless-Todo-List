# ########################################
# Create role for Lambda
# ########################################

resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


# ##############################################
# IAM Policy for Lambda to access DynamoDB
# ##############################################

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "${var.app_name}-lambda-dynamodb-policy"
  description = "Policy for Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem"
        ]
        Resource = [
          aws_dynamodb_table.dynamodb_table.arn,
          "${aws_dynamodb_table.dynamodb_table.arn}/*"
        ]
      },
      # logging
      #   {
      #     Effect = "Allow"
      #     Action = [
      #       "logs:CreateLogGroup",
      #       "logs:CreateLogStream",
      #       "logs:PutLogEvents"
      #     ]
      #     Resource = "arn:aws:logs:*:*:*"
      #   }
    ]
  })
}

# # Attach policy to role
# resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
# }

# # Archive the Lambda function code
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   output_path = "lambda_function.zip"
#   source {
#     content  = file("${path.module}/lambda_function.py")
#     filename = "lambda_function.py"
#   }
# }
