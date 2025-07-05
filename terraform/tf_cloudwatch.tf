# ###############################
# CloudWatch Log Group for API Gateway
# ###############################
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.app_name}-api-gateway"
  retention_in_days = 14

  tags = {
    Name = "${var.app_name}-api-gateway-logs"
  }
}