provider "aws" {
  region = "ap-southeast-2"
}

variable "lambda_version" {
  default = "1.0.0"
}

variable "s3_bucket" {
  default = "codingtips-node-bucket"
}
