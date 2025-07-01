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

variable "aws_lambda_function_compatible_architectures" {
  description = "AWS Lambda function compatible architectures"
  type        = list(string)
  default     = ["x86_64"]
}

# ###############################
# AWS API Gateway
# ###############################

variable "aws_api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "csv_reader_api"
}

variable "aws_api_gateway_path_csv_reader" {
  description = "API path"
  type        = string
  default     = "csv-reader"
}

variable "aws_api_gateway_stage_dev" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "dev"
}

