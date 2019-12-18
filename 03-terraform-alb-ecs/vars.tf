variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-southeast-2"
}

variable "instance_type" {
  default     = "t2.large"
  description = "AWS instance type"
}
