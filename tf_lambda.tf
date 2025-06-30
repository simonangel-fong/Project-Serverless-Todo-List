# ###############################
# Package the local function file
# ###############################
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/main.py"
  output_path = "${path.module}/main.zip"
}

# # Common dependencies layer
# resource "aws_lambda_layer_version" "lambda_layer" {
#   layer_name          = "chatbot_dependencies_layer"
#   filename            = "./lambda/layer.zip"
#   description         = "Chatbot dependencies for Lambda functions"
#   compatible_runtimes = ["python3.11"]

#   compatible_architectures = ["x86_64"]

# }



# ###############################
# Create a lambda function
# ###############################

resource "aws_lambda_function" "lambda_function" {

  function_name    = var.aws_lambda_function_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = var.aws_lambda_function_handler
  runtime          = var.aws_lambda_function_runtime
  role             = aws_iam_role.lambda_role.arn
  timeout          = 30

  #   # layer
  #   layers = [aws_lambda_layer_version.lambda_layer.arn]

  tags = {
    Name = var.aws_lambda_function_name
  }
}
