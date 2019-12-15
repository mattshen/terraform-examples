resource "aws_lambda_function" "get-tips-lambda" {
  function_name = "codingTips-get"
  handler       = "index.handler"
  role          = "${aws_iam_role.lambda-iam-role.arn}"
  runtime       = "nodejs8.10"
  memory_size   = 128

  filename         = "../getLambda.zip"
  source_code_hash = "${base64sha256(file("../getLambda.zip"))}"
}

resource "aws_lambda_permission" "api-gate-invoket-get-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get-tips-lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.execution_arn}/*/*"
}
