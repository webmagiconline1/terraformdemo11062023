resource "aws_s3_bucket" "non-prod-bucket" {
  bucket = "s312062023"
  tags = {
    Owner = "Dabeer"
  }
}