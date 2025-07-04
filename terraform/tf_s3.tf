# ########################################
# Create bucket for static web host
# ########################################

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}.${var.domain_name}"

  force_destroy = true

  tags = {
    Name = "${var.app_name}.${var.domain_name}"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enabe bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ########################################
# Upload web files
# ########################################

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/../s3"
}

# update S3 object resource for hosting bucket files
resource "aws_s3_object" "web_file" {
  bucket = aws_s3_bucket.s3_bucket.id

  # loop all files
  for_each     = module.template_files.files
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  # ETag of the S3 object
  etag = each.value.digests.md5
}
