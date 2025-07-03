# # Output the regional domain name for DNS CNAME/Alias record
# output "api_gateway_domain_name" {
#   description = "Domain name for DNS record"
#   value       = data.aws_api_gateway_domain_name.api_domain.regional_domain_name
# }

# # Output custom domain
# output "custom_domain_name" {
#   description = "Your custom domain name"
#   value       = data.aws_api_gateway_domain_name.api_domain.domain_name
# }
