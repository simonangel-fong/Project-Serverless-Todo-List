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
# IAM Policy: Allow Lambda to access DynamoDB
# ##############################################

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "${var.app_name}-lambda-access-dynamodb-policy"
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
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
  depends_on = [aws_dynamodb_table.dynamodb_table]
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# # Archive the Lambda function code
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   output_path = "lambda_function.zip"
#   source {
#     content  = file("${path.module}/lambda_function.py")
#     filename = "lambda_function.py"
#   }
# }


# ###############################
# IAM role for API to invoke lambda service
# ###############################

resource "aws_lambda_permission" "api_gateway_invoke_get" {
  function_name = aws_lambda_function.lambda_function.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGatewayGET"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}
