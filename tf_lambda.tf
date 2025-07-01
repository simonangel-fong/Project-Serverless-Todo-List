# ###############################
# Package the local function file
# ###############################
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/main.py"
  output_path = "${path.module}/main.zip"
}

# data "archive_file" "lambda_layer_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/lambda/python/"
#   output_path = "${path.module}/layer.zip"
# }

# Add dependencies layer
resource "aws_lambda_layer_version" "lambda_function_layer" {
  layer_name               = "${var.aws_lambda_function_name}-layer"
  description              = "Dependencies for Lambda functions ${var.aws_lambda_function_name}"
  compatible_runtimes      = [var.aws_lambda_function_runtime]
  compatible_architectures = ["x86_64"]

  # filename = data.archive_file.lambda_layer_zip.output_path
  filename         = "./layer.zip"
  source_code_hash = filebase64sha256("layer.zip") # trigger relace layer
  # source_code_hash = filebase64sha256(data.archive_file.lambda_layer_zip.output_path) # trigger relace layer
}

# ###############################
# Create a lambda function
# ###############################

resource "aws_lambda_function" "lambda_function" {

  function_name    = var.aws_lambda_function_name
  filename         = data.archive_file.lambda_function_zip.output_path
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  handler          = var.aws_lambda_function_handler
  runtime          = var.aws_lambda_function_runtime
  role             = aws_iam_role.lambda_role.arn
  timeout          = 30

  # layer
  layers = [aws_lambda_layer_version.lambda_function_layer.arn]

  tags = {
    Name = var.aws_lambda_function_name
  }
}
