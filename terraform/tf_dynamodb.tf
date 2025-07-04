# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "${var.app_name}-table"
  billing_mode = "PAY_PER_REQUEST"

  import_table {
    input_format           = "CSV"
    input_compression_type = "NONE"
    s3_bucket_source {
      bucket     = aws_s3_bucket.s3_bucket.id
      key_prefix = "todo-list.csv"
    }
  }

  hash_key = "id"

  attribute {
    name = "id"
    type = "N" # String type for ID
  }

  # attribute {
  #   name = "status"
  #   type = "S"
  # }

  # # GSI: query by status
  # global_secondary_index {
  #   name            = "status-index"
  #   hash_key        = "status"
  #   projection_type = "ALL"
  # }

  # attribute {
  #   name = "task"
  #   type = "S"
  # }

  # global_secondary_index {
  #   name            = "task-index"
  #   hash_key        = "task"
  #   projection_type = "ALL"
  # }

  # attribute {
  #   name = "priority"
  #   type = "S"
  # }

  # # GSI: query by priority
  # global_secondary_index {
  #   name            = "priority-index"
  #   hash_key        = "priority"
  #   projection_type = "ALL"
  # }

  tags = {
    Name = "${var.app_name}-tasks-table"
  }
}

# # ########################################
# # IAM Role for Lambda function to import data
# # ########################################

# resource "aws_iam_role" "lambda_import_role" {
#   name = "${var.app_name}-lambda-import-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # IAM policy for Lambda to access S3 and DynamoDB
# resource "aws_iam_role_policy" "lambda_import_policy" {
#   name = "${var.app_name}-lambda-import-policy"
#   role = aws_iam_role.lambda_import_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ]
#         Resource = "arn:aws:logs:*:*:*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:ListBucket"
#         ]
#         Resource = [
#           aws_s3_bucket.s3_bucket.arn,
#           "${aws_s3_bucket.s3_bucket.arn}/*"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "dynamodb:PutItem",
#           "dynamodb:BatchWriteItem",
#           "dynamodb:Scan",
#           "dynamodb:Query"
#         ]
#         Resource = [
#           aws_dynamodb_table.tasks_table.arn,
#           "${aws_dynamodb_table.tasks_table.arn}/*"
#         ]
#       }
#     ]
#   })
# }

# # ########################################
# # Lambda function for CSV import
# # ########################################

# resource "aws_lambda_function" "csv_import" {
#   filename      = "csv_import.zip"
#   function_name = "${var.app_name}-csv-import"
#   role          = aws_iam_role.lambda_import_role.arn
#   handler       = "index.handler"
#   runtime       = "python3.9"
#   timeout       = 300

#   environment {
#     variables = {
#       DYNAMODB_TABLE_NAME = aws_dynamodb_table.tasks_table.name
#       S3_BUCKET_NAME      = aws_s3_bucket.s3_bucket.bucket
#     }
#   }

#   depends_on = [
#     aws_iam_role_policy.lambda_import_policy,
#     aws_cloudwatch_log_group.lambda_logs,
#   ]
# }

# # CloudWatch Log Group for Lambda
# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${var.app_name}-csv-import"
#   retention_in_days = 14
# }

# # ########################################
# # S3 Bucket notification to trigger Lambda
# # ########################################

# resource "aws_s3_bucket_notification" "csv_upload_notification" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   lambda_function {
#     lambda_function_arn = aws_lambda_function.csv_import.arn
#     events              = ["s3:ObjectCreated:*"]
#     filter_prefix       = ""
#     filter_suffix       = ".csv"
#   }

#   depends_on = [aws_lambda_permission.s3_invoke_lambda]
# }

# # Permission for S3 to invoke Lambda
# resource "aws_lambda_permission" "s3_invoke_lambda" {
#   statement_id  = "AllowExecutionFromS3Bucket"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.csv_import.function_name
#   principal     = "s3.amazonaws.com"
#   source_arn    = aws_s3_bucket.s3_bucket.arn
# }

# # ########################################
# # Outputs
# # ########################################

# output "dynamodb_table_name" {
#   description = "Name of the DynamoDB table"
#   value       = aws_dynamodb_table.tasks_table.name
# }

# output "dynamodb_table_arn" {
#   description = "ARN of the DynamoDB table"
#   value       = aws_dynamodb_table.tasks_table.arn
# }

# output "lambda_function_name" {
#   description = "Name of the Lambda function for CSV import"
#   value       = aws_lambda_function.csv_import.function_name
# }
