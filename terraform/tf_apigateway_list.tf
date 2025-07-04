# # ###############################
# # API Gateway: List
# # ###############################

# resource "aws_api_gateway_rest_api" "rest_api" {
#   name        = "${var.app_name}-api-gateway-list"
#   description = "${var.app_name} API Gateway - List"

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }

#   tags = {
#     Name = "${var.app_name}-api-gateway-list"
#   }
# }

# resource "aws_api_gateway_resource" "list_resource" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
#   path_part   = "list"
# }

# # method get
# resource "aws_api_gateway_method" "method_get" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.list_resource.id
#   http_method = "GET"

#   authorization = "NONE"
# }

# # get integrate
# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.list_resource.id
#   http_method             = aws_api_gateway_method.method_get.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   # type                    = "AWS"
#   uri = aws_lambda_function.lambda_function.invoke_arn
# }

# # get response
# resource "aws_api_gateway_method_response" "method_response_get" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.list_resource.id
#   http_method = aws_api_gateway_method.method_get.http_method
#   status_code = "200"

#   //cors section
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods" = true,
#     "method.response.header.Access-Control-Allow-Origin"  = true
#   }

# }

# # get integation response
# resource "aws_api_gateway_integration_response" "integration_response_get" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.list_resource.id
#   http_method = aws_api_gateway_method.method_get.http_method
#   status_code = aws_api_gateway_method_response.method_response_get.status_code


#   //cors
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }

#   depends_on = [
#     aws_api_gateway_method.method_get,
#     aws_api_gateway_integration.lambda_integration
#   ]
# }

# # option cors
# resource "aws_api_gateway_method" "method_options_cors" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.list_resource.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # option integration: cors
# resource "aws_api_gateway_integration" "integration_options" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.list_resource.id
#   http_method             = aws_api_gateway_method.method_options_cors.http_method
#   integration_http_method = "OPTIONS"
#   type                    = "MOCK"
#   request_templates = {
#     "application/json" = "{\"statusCode\": 200}"
#   }
# }

# # option: method response
# resource "aws_api_gateway_method_response" "method_response_options" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.list_resource.id
#   http_method = aws_api_gateway_method.method_options_cors.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods" = true,
#     "method.response.header.Access-Control-Allow-Origin"  = true
#   }
# }

# # option integration_response
# resource "aws_api_gateway_integration_response" "integration_response_option" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.list_resource.id
#   http_method = aws_api_gateway_method.method_options_cors.http_method
#   status_code = aws_api_gateway_method_response.method_response_options.status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }

#   depends_on = [
#     aws_api_gateway_method.method_options_cors,
#     aws_api_gateway_integration.integration_options,
#   ]
# }

# # ###############################
# # API Gateway Deployment: a snapshot of the REST API configuration
# # ###############################
# resource "aws_api_gateway_deployment" "rest_api_deployment" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id

#   triggers = {
#     redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   depends_on = [
#     aws_api_gateway_integration.lambda_integration,
#     aws_api_gateway_integration_response.integration_response_get,
#     aws_api_gateway_method.method_get,
#     aws_api_gateway_method_response.method_response_get,
#     aws_api_gateway_method.method_options_cors,
#     aws_api_gateway_integration.integration_options,
#     aws_api_gateway_method_response.method_response_options,
#     aws_api_gateway_integration_response.integration_response_option
#   ]
# }

# resource "aws_api_gateway_stage" "stage" {
#   deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   stage_name    = var.aws_api_gateway_stage_dev
# }

# # ###############################
# # API Gateway Customer Domain Name: mapping
# # ###############################

# # data "aws_api_gateway_domain_name" "api_domain" {
# #   domain_name = "api.arguswatcher.net"
# # }

# # resource "aws_api_gateway_base_path_mapping" "api_domain_mapping" {
# #   api_id      = aws_api_gateway_rest_api.rest_api.id
# #   stage_name  = aws_api_gateway_stage.stage.stage_name
# #   domain_name = data.aws_api_gateway_domain_name.api_domain.domain_name
# #   base_path   = ""

# #   depends_on = [aws_api_gateway_stage.stage]
# # }
