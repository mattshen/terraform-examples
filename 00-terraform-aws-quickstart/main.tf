provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "mzfc-test-2"
  acl    = "private"

  tags {
    Name        = "Created by terraform"
    Environment = "Dev"
  }
}
