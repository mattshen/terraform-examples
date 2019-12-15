resource "aws_lambda_function" "post-tips-lambda" {
  function_name = "codeTips-post"
  handler       = "index.handler"
  role          = "${aws_iam_role.lambda-iam-role.arn}"
  runtime       = "nodejs8.10"
  memory_size   = 128

  filename         = "../postLambda.zip"
  source_code_hash = "${base64sha256(file("../postLambda.zip"))}"
}

resource "aws_lambda_permission" "api-gateway-invoke-post-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.post-tips-lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.execution_arn}/*/*"
}
