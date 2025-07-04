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
