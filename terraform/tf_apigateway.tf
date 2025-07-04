# ###############################
# API Gateway: List
# ###############################

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.app_name}-api-gateway"
  description = "${var.app_name} API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = "${var.app_name}-api-gateway-list"
  }
}

# ###############################
# API Gateway Deployment: a snapshot of the REST API configuration
# ###############################
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      # Web Root + CORS
      aws_api_gateway_method.root_method_options_cors,
      aws_api_gateway_integration.root_integration_options,
      aws_api_gateway_method_response.root_method_response_options,
      aws_api_gateway_integration_response.root_integration_response_options,

      # Web Proxy
      aws_api_gateway_resource.root_proxy,
      aws_api_gateway_method.proxy_method_get,
      aws_api_gateway_integration.proxy_s3_integration,
      aws_api_gateway_method_response.proxy_method_response_get,
      aws_api_gateway_integration_response.proxy_integration_response_get,

      # api List
      aws_api_gateway_integration.list_lambda_integration,
      aws_api_gateway_integration_response.list_integration_response_get,
      aws_api_gateway_method.list_method_get,
      aws_api_gateway_method_response.list_method_response_get,
      aws_api_gateway_method.list_method_options_cors,
      aws_api_gateway_integration.list_integration_options,
      aws_api_gateway_method_response.list_method_response_options,
      aws_api_gateway_integration_response.list_integration_response_option
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    # Web Root + CORS
    aws_api_gateway_method.root_method_options_cors,
    aws_api_gateway_integration.root_integration_options,
    aws_api_gateway_method_response.root_method_response_options,
    aws_api_gateway_integration_response.root_integration_response_options,

    # Web Proxy
    aws_api_gateway_resource.root_proxy,
    aws_api_gateway_method.proxy_method_get,
    aws_api_gateway_integration.proxy_s3_integration,
    aws_api_gateway_method_response.proxy_method_response_get,
    aws_api_gateway_integration_response.proxy_integration_response_get,

    # api List
    aws_api_gateway_integration.list_lambda_integration,
    aws_api_gateway_integration_response.list_integration_response_get,
    aws_api_gateway_method.list_method_get,
    aws_api_gateway_method_response.list_method_response_get,
    aws_api_gateway_method.list_method_options_cors,
    aws_api_gateway_integration.list_integration_options,
    aws_api_gateway_method_response.list_method_response_options,
    aws_api_gateway_integration_response.list_integration_response_option
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.aws_api_gateway_stage_dev
}

# ###############################
# API Gateway Customer Domain Name: mapping
# ###############################

data "aws_api_gateway_domain_name" "api_domain" {
  domain_name = "todo-app.arguswatcher.net"
}

resource "aws_api_gateway_base_path_mapping" "api_domain_mapping" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = data.aws_api_gateway_domain_name.api_domain.domain_name
  base_path   = ""

  depends_on = [aws_api_gateway_stage.stage]
}
