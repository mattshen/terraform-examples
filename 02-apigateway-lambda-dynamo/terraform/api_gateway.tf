resource "aws_api_gateway_rest_api" "codingtips-api-gateway" {
  name        = "CodingTipsAPI"
  description = "API to access codingtips application"
  body        = "${data.template_file.codingtips_api_swagger.rendered}"
}

data "template_file" "codingtips_api_swagger" {
  template = "${file("swagger.yaml")}"

  vars {
    get_lambda_arn  = "${aws_lambda_function.get-tips-lambda.invoke_arn}"
    post_lambda_arn = "${aws_lambda_function.post-tips-lambda.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "codingtips-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.codingtips-api-gateway.id}"
  stage_name = "mzfc-test"
}

resource "aws_api_gateway_method_settings" "codingtips-api-gateway-settings" {
  rest_api_id = "${aws_api_gateway_rest_api.codingtips-api-gateway.id}"
  stage_name  = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.stage_name}"
  method_path = "*/*"
  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled        = true
    data_trace_enabled     = true
    logging_level          = "INFO"
    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

output "url" {
  value = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.invoke_url}/test"
}
