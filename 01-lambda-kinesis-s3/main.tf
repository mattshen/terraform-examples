provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "matts-test-bucket" {
  bucket = "mzfc-test-3"
  acl    = "private"

  tags {
    Environment = "test"
  }
}

resource "aws_kinesis_stream" "mzfc-stream-1" {
  name        = "mzfc-stream-1"
  shard_count = 1

  tags {
    Environment = "test"
  }
}

resource "aws_iam_role" "role_for_lambda" {
  name = "matt_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-access-policy-attachment" {
  role       = "${aws_iam_role.role_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "kinesis-access-policy-attachment" {
  role       = "${aws_iam_role.role_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-access-policy-attachment" {
  role       = "${aws_iam_role.role_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_lambda_function" "matts-test-lambda" {
  filename         = "build/libs/terraform-lambda-kineis-s3.jar"
  function_name    = "matts-test-lambda"
  role             = "${aws_iam_role.role_for_lambda.arn}"
  handler          = "Handler"
  source_code_hash = "${base64sha256(file("build/libs/terraform-lambda-kineis-s3.jar"))}"
  runtime          = "java8"
  timeout          = 300
  memory_size      = 512
  description      = "Test lambda created by terraform"

  environment {
    variables {
      BUCKET_NAME = "${aws_s3_bucket.matts-test-bucket.bucket}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  batch_size        = 3
  event_source_arn  = "${aws_kinesis_stream.mzfc-stream-1.arn}"
  enabled           = true
  function_name     = "${aws_lambda_function.matts-test-lambda.arn}"
  starting_position = "LATEST"
}
