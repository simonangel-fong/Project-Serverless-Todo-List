# # ###############################
# # Package the local function file
# # ###############################

# data "archive_file" "lambda_function_zip" {
#   type        = "zip"
#   source_file = "${path.module}/../lambda/list.py"
#   output_path = "${path.module}/list.zip"
# }

# # Add dependencies layer
# resource "aws_lambda_layer_version" "lambda_function_layer" {
#   layer_name               = "${var.app_name}-lambda-layer"
#   description              = "Dependencies for Lambda functions ${var.app_name}-lambda-function"
#   compatible_runtimes      = [var.aws_lambda_function_runtime]
#   compatible_architectures = ["x86_64"]

#   # filename = data.archive_file.lambda_layer_zip.output_path
#   filename         = "layer.zip"
#   source_code_hash = filebase64sha256("../lambda/layer.zip") # trigger relace layer
#   # source_code_hash = filebase64sha256(data.archive_file.lambda_layer_zip.output_path) # trigger relace layer
# }

# # ###############################
# # Create a lambda function
# # ###############################

# resource "aws_lambda_function" "lambda_function" {

#   function_name    = "${var.app_name}-lambda-function"
#   filename         = data.archive_file.lambda_function_zip.output_path
#   source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
#   handler          = var.aws_lambda_function_handler
#   runtime          = var.aws_lambda_function_runtime
#   role             = aws_iam_role.lambda_role.arn
#   timeout          = 30

#   # layer
#   layers = [aws_lambda_layer_version.lambda_function_layer.arn]

#   tags = {
#     Name = "${var.app_name}-lambda-function"
#   }
# }
