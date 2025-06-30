# ###############################
# Provider
# ###############################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

# ###############################
# AWS Lambda
# ###############################

variable "aws_lambda_function_name" {
  description = "AWS Lambda function name"
  type        = string
  default     = "csv_reader"
}


variable "aws_lambda_function_handler" {
  description = "AWS Lambda function handler: file name.function name"
  type        = string
  default     = "main.lambda_handler"
}

variable "aws_lambda_function_runtime" {
  description = "AWS Lambda function runtime"
  type        = string
  default     = "python3.11"
}
