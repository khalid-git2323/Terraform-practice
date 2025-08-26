resource "aws_s3_bucket" "sample" {
  bucket = var.bucket_name

  tags = {
    name=var.bucket_name
  }
}