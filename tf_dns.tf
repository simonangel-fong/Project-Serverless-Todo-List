# resource "aws_acm_certificate" "acm_cert" {
#   domain_name       = "*.${var.web_domain_name}"
#   validation_method = var.acm_validation_method

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "acm_cert_valid" {
#   certificate_arn         = aws_acm_certificate.acm_cert.arn
#   validation_record_fqdns = [for record in aws_acm_certificate.acm_cert.domain_validation_options : record.resource_record_name]
# }

# resource "aws_api_gateway_domain_name" "aws_api_domain" {
#   domain_name              = "${var.web_subdomain_name}.${var.web_domain_name}"
#   regional_certificate_arn = aws_acm_certificate.acm_cert.arn

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }

#   depends_on = [aws_acm_certificate_validation.acm_cert_valid]
# }
