# ########################################
# S3 bucket
# ########################################
output "aws_s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

# ########################################
# DynamoDB Table
# ########################################
output "aws_dynamodb_table_name" {
  description = "S3 bucket name"
  value       = aws_dynamodb_table.dynamodb_table.id
}

# ########################################
# Cloudfront Table
# ########################################
output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_website_distribution.domain_name
}
