# ###############################
# Root: get
# ###############################

# Root method: GET
resource "aws_api_gateway_method" "root_method_get" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Root Integration: http with S3
resource "aws_api_gateway_integration" "proxy_root_integration_s3" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://todo-app.arguswatcher.net.s3-website.ca-central-1.amazonaws.com/index.html"

  # request_parameters = {
  #   "integration.request.header.x-amz-acl" = "'public-read'"
  # }
}

# Root Method responses: for root path
resource "aws_api_gateway_method_response" "root_method_response_get" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Content-Type"                 = true
  }
}

# Root Integration responses: get
resource "aws_api_gateway_integration_response" "root_integration_response_get" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method_get.http_method
  status_code = aws_api_gateway_method_response.root_method_response_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Content-Type"                 = "integration.response.header.Content-Type"
  }
}

# ###############################
# Root: option
# ###############################

# Root method: OPTIONS (CORS)
resource "aws_api_gateway_method" "root_method_options_cors" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Root integration:: option (CORS)
resource "aws_api_gateway_integration" "root_integration_options" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method_options_cors.http_method

  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Root method response:: option (CORS)
resource "aws_api_gateway_method_response" "root_method_response_options" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method_options_cors.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Content-Type"                 = true
  }
}

resource "aws_api_gateway_integration_response" "root_integration_response_options" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method_options_cors.http_method
  status_code = aws_api_gateway_method_response.root_method_response_options.status_code

  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Content-Type"                 = "integration.response.header.Content-Type"
  }
}
