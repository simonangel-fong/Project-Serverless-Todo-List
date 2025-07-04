# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "${var.app_name}-table"
  billing_mode = "PAY_PER_REQUEST"

  import_table {
    input_format           = "CSV"
    input_compression_type = "NONE"
    s3_bucket_source {
      bucket     = aws_s3_bucket.s3_bucket.id
      key_prefix = "data/todo-list.csv"
    }
  }

  hash_key = "id"

  attribute {
    name = "id"
    type = "N" # String type for ID
  }

  tags = {
    Name = "${var.app_name}-tasks-table"
  }
}
