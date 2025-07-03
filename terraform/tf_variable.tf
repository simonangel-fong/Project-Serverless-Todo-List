# ########################################
# Application variables
# ########################################

variable "app_name" {
  type        = string
  description = "Name of application"
  # only lowercase alphanumeric characters and hyphens allowed
  # default = "todo-app" # replaced by application name
}

variable "domain_name" {
  type        = string
  description = "Domain name for application"
  # default     = "arguswatcher.net" # replaced by the record hosted on cloudflare
}

# ########################################
# Provider
# ########################################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1" # replaced by the aws region anme
}

# variable "cloudflare_api_token" {
#   description = "Cloudflare API token"
#   type        = string
#   sensitive   = true
# }


# ###############################
# AWS Lambda
# ###############################

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

variable "aws_api_gateway_path_list" {
  description = "API path"
  type        = string
  default     = "list"
}

variable "aws_api_gateway_stage_dev" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "dev"
}

# ###############################
# AWS ACM to verify the cf cert
# ###############################

variable "acm_validation_method" {
  description = "Method for validating the ACM certificate (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

variable "cloudflare_zone_id" {
  description = "Method for validating the ACM certificate (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}


