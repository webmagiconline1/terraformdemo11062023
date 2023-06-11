resource "aws_s3_bucket" "non-prod-bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}