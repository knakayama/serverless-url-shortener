resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.name}"
  description = "${replace(var.name, "-", " ")}"
}

resource "aws_api_gateway_method" "api" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method             = "${aws_api_gateway_method.api.http_method}"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method = "${aws_api_gateway_method.api.http_method}"
  status_code = 200
}

resource "aws_api_gateway_integration_response" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method = "${aws_api_gateway_method.api.http_method}"
  status_code = "${aws_api_gateway_method_response.api.status_code}"
}

resource "aws_api_gateway_deployment" "api" {
  depends_on  = ["aws_api_gateway_integration.api"]
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "prod"
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${element(split(":", var.lambda_arn), 4)}:${aws_api_gateway_rest_api.api.id}/*/POST/"
}
