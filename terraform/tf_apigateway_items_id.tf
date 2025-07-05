# ###############################
# API Gateway: get /items/{id}
# ###############################

# get method
resource "aws_api_gateway_method" "method_get_item_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_item_by_id.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

# integration
resource "aws_api_gateway_integration" "integration_lambda_get_item_by_id" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_item_by_id.id
  http_method             = aws_api_gateway_method.method_get_item_by_id.http_method
  integration_http_method = "POST" # Always POST for Lambda proxy
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# Method Response
resource "aws_api_gateway_method_response" "method_response_get_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.method_get_item_by_id.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Integration Response
resource "aws_api_gateway_integration_response" "integration_response_get_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.method_get_item_by_id.http_method
  status_code = aws_api_gateway_method_response.method_response_get_item_by_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.method_get_item_by_id,
    aws_api_gateway_integration.integration_lambda_get_item_by_id
  ]
}

# ###############################
# API Gateway: put /items/{id}
# ###############################

resource "aws_api_gateway_method" "method_put_item_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_item_by_id.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "integration_lambda_put_item_by_id" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_item_by_id.id
  http_method             = aws_api_gateway_method.method_put_item_by_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "method_response_put_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.method_put_item_by_id.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_put_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.method_put_item_by_id.http_method
  status_code = aws_api_gateway_method_response.method_response_put_item_by_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.method_put_item_by_id,
    aws_api_gateway_integration.integration_lambda_put_item_by_id
  ]
}


# ###############################
# API Gateway: delete /items/{id}
# ###############################

resource "aws_api_gateway_method" "method_delete_item_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_item_by_id.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "integration_lambda_delete_item_by_id" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_item_by_id.id
  http_method             = aws_api_gateway_method.method_delete_item_by_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "method_response_delete_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.method_delete_item_by_id.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_delete_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.method_delete_item_by_id.http_method
  status_code = aws_api_gateway_method_response.method_response_delete_item_by_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.method_delete_item_by_id,
    aws_api_gateway_integration.integration_lambda_delete_item_by_id
  ]
}

# ###############################
# API Gateway: option cors
# ###############################

resource "aws_api_gateway_method" "options_item_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_item_by_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.options_item_by_id.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_response_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.options_item_by_id.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource_item_by_id.id
  http_method = aws_api_gateway_method.options_item_by_id.http_method
  status_code = aws_api_gateway_method_response.options_response_item_by_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options_item_by_id,
    aws_api_gateway_integration.options_integration_item_by_id
  ]
}
