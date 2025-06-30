# IAM role for Lambda function

# ###############################
# IAM role for Lambda: 
# ###############################

# creates an IAM role for lambda
resource "aws_iam_role" "lambda_role" {
  # role name
  name = "${var.aws_lambda_function_name}-role"

  # role policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          Service = "lambda.amazonaws.com" # grants permission to the Lambda service
        }
        Action = "sts:AssumeRole"
        Effect = "Allow"
      }
    ]
  })

}

# Create a policy to allows the Lambda function to perform s3:GetObject actions
resource "aws_iam_policy" "lambda_s3_access_policy" {
  name        = "csv-reader-s3-policy"
  description = "Allows Lambda function to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::aws-api.arguswatcher.net/*"
      }
    ]
  })
}

# attaches an IAM policy to lambda role
resource "aws_iam_role_policy_attachment" "lambda_s3_access_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_access_policy.arn
}
