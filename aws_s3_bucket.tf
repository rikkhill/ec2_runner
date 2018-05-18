resource "aws_s3_bucket" "b" {
  bucket = "${var.collection_name}-bucket"
  acl    = "private"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}