# ###############################
# API Gateway
# ###############################

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = var.aws_api_gateway_name
  description = "API Gateway to read csv file"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = var.aws_api_gateway_name
  }
}

# define a path
resource "aws_api_gateway_resource" "api_path_csv_reader" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.aws_api_gateway_path_csv_reader
}

# define method (get)
resource "aws_api_gateway_method" "api_path_csv_reader_get" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_path_csv_reader.id
  http_method   = "GET"
  authorization = "NONE"
}

# define option for cros
resource "aws_api_gateway_method" "api_path_csv_reader_options" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_path_csv_reader.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# integrate with lambda
resource "aws_api_gateway_integration" "api_path_csv_reader_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_path_csv_reader.id
  http_method             = aws_api_gateway_method.api_path_csv_reader_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# # define response
# resource "aws_api_gateway_method_response" "api_path_csv_reader_get_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_path_csv_reader.id
#   http_method = aws_api_gateway_method.api_path_csv_reader_get.http_method
#   status_code = "200"
# }

# # intergrate with response
# resource "aws_api_gateway_integration_response" "api_path_csv_reader_get_response_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_path_csv_reader.id
#   http_method = aws_api_gateway_method.api_path_csv_reader_get.http_method
#   status_code = aws_api_gateway_method_response.api_path_csv_reader_get_response.status_code

#   response_templates = {
#     "application/json" = ""
#   }
# }

# ###############################
# API Gateway Deployment: a snapshot of the REST API configuration
# ###############################

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  # redeploy if get changed
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_path_csv_reader.id,               # path
      aws_api_gateway_method.api_path_csv_reader_get.id,             # method
      aws_api_gateway_integration.api_path_csv_reader_get_lambda.id, # method
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.api_path_csv_reader_get,
    aws_api_gateway_integration.api_path_csv_reader_get_lambda
    # aws_api_gateway_method_response.api_path_csv_reader_get_response,
    # aws_api_gateway_integration_response.api_path_csv_reader_get_response_integration
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.aws_api_gateway_stage_dev
}

