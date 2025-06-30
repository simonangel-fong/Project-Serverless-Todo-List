# IAM role for Lambda function



# ###############################
# IAM role for Lambda: 
# ###############################
resource "aws_iam_role" "lambda_role" {
  # role name
  name = "${var.aws_lambda_function_name}-role"

  # role policy
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
