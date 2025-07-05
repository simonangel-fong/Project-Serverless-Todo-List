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
    Name = "${var.app_name}-api-gateway"
  }
}

# /items
resource "aws_api_gateway_resource" "resource_items" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "items"
}

# /items/id
resource "aws_api_gateway_resource" "resource_item_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.resource_items.id
  path_part   = "{id}"
}

# ###############################
# API Gateway Deployment: a snapshot of the REST API configuration
# ###############################
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  # Redeploy when any method/integration changes
  triggers = {
    redeployment = sha1(jsonencode([
      # GET /items
      aws_api_gateway_method.method_get_all.id,
      aws_api_gateway_integration.integration_lambda_get_all.id,
      aws_api_gateway_method_response.method_response_get_all.id,
      aws_api_gateway_integration_response.integration_response_get_all.id,

      # POST /items
      aws_api_gateway_method.method_post_item.id,
      aws_api_gateway_integration.integration_lambda_post_item.id,
      aws_api_gateway_method_response.method_response_post_item.id,
      aws_api_gateway_integration_response.integration_response_post_item.id,

      # OPTIONS /items
      aws_api_gateway_method.method_options_cors.id,
      aws_api_gateway_integration.integration_options_cors.id,
      aws_api_gateway_method_response.method_response_options_cors.id,
      aws_api_gateway_integration_response.integration_response_option_cors.id,

      # GET /items/{id}
      aws_api_gateway_resource.resource_item_by_id.id,
      aws_api_gateway_method.method_get_item_by_id.id,
      aws_api_gateway_integration.integration_lambda_get_item_by_id.id,
      aws_api_gateway_method_response.method_response_get_item_by_id.id,
      aws_api_gateway_integration_response.integration_response_get_item_by_id.id,

      # PUT /items/{id}
      aws_api_gateway_method.method_put_item_by_id.id,
      aws_api_gateway_integration.integration_lambda_put_item_by_id.id,
      aws_api_gateway_method_response.method_response_put_item_by_id.id,
      aws_api_gateway_integration_response.integration_response_put_item_by_id.id,

      # DELETE /items/{id}
      aws_api_gateway_method.method_delete_item_by_id.id,
      aws_api_gateway_integration.integration_lambda_delete_item_by_id.id,
      aws_api_gateway_method_response.method_response_delete_item_by_id.id,
      aws_api_gateway_integration_response.integration_response_delete_item_by_id.id,

      # OPTIONS /items/{id} for CORS
      aws_api_gateway_method.options_item_by_id.id,
      aws_api_gateway_integration.options_integration_item_by_id.id,
      aws_api_gateway_method_response.options_response_item_by_id.id,
      aws_api_gateway_integration_response.options_integration_response_item_by_id.id,

    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    # GET /items
    aws_api_gateway_method.method_get_all,
    aws_api_gateway_integration.integration_lambda_get_all,
    aws_api_gateway_method_response.method_response_get_all,
    aws_api_gateway_integration_response.integration_response_get_all,

    # POST /items
    aws_api_gateway_method.method_post_item,
    aws_api_gateway_integration.integration_lambda_post_item,
    aws_api_gateway_method_response.method_response_post_item,
    aws_api_gateway_integration_response.integration_response_post_item,

    # OPTIONS /items
    aws_api_gateway_method.method_options_cors,
    aws_api_gateway_integration.integration_options_cors,
    aws_api_gateway_method_response.method_response_options_cors,
    aws_api_gateway_integration_response.integration_response_option_cors,

    # GET /items/{id}
    aws_api_gateway_resource.resource_item_by_id,
    aws_api_gateway_method.method_get_item_by_id,
    aws_api_gateway_integration.integration_lambda_get_item_by_id,
    aws_api_gateway_method_response.method_response_get_item_by_id,
    aws_api_gateway_integration_response.integration_response_get_item_by_id,

    # PUT /items/{id}
    aws_api_gateway_method.method_put_item_by_id,
    aws_api_gateway_integration.integration_lambda_put_item_by_id,
    aws_api_gateway_method_response.method_response_put_item_by_id,
    aws_api_gateway_integration_response.integration_response_put_item_by_id,

    # DELETE /items/{id}
    aws_api_gateway_method.method_delete_item_by_id,
    aws_api_gateway_integration.integration_lambda_delete_item_by_id,
    aws_api_gateway_method_response.method_response_delete_item_by_id,
    aws_api_gateway_integration_response.integration_response_delete_item_by_id,

    # OPTIONS /items/{id} for CORS
    aws_api_gateway_method.options_item_by_id,
    aws_api_gateway_integration.options_integration_item_by_id,
    aws_api_gateway_method_response.options_response_item_by_id,
    aws_api_gateway_integration_response.options_integration_response_item_by_id,

  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id

  variables = {
    lambdaAlias = "live"
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  xray_tracing_enabled  = true
  cache_cluster_enabled = false

  depends_on = [
    aws_cloudwatch_log_group.api_gateway_logs,
    aws_api_gateway_account.account_settings
  ]
}

# register the logging role
resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn

  depends_on = [aws_iam_role_policy.api_gateway_cloudwatch_policy]
}

# ###############################
# API Gateway Customer Domain Name: mapping
# ###############################

data "aws_api_gateway_domain_name" "api_domain" {
  domain_name = "todo-app-api.arguswatcher.net"
}

resource "aws_api_gateway_base_path_mapping" "api_domain_mapping" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  domain_name = data.aws_api_gateway_domain_name.api_domain.domain_name
  base_path   = ""

  depends_on = [aws_api_gateway_stage.api_stage]
}
