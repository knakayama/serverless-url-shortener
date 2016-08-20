module "iam" {
  source = "../modules/iam"

  name = "${var.name}"
}

module "s3" {
  source = "../modules/s3"

  name      = "${var.name}"
  s3_config = "${var.s3_config}"
}

module "cloudfront" {
  source = "../modules/cloudfront"

  aws_region          = "${var.aws_region}"
  name                = "${var.name}"
  cf_config           = "${var.cf_config}"
  s3_bucket           = "${module.s3.bucket}"
  s3_website_endpoint = "${module.s3.website_endpoint}"
  api_gateway_id      = "${module.api_gateway.id}"
  domain_config       = "${var.domain_config}"
}

module "api_gateway" {
  source = "../modules/api_gateway"

  name       = "${var.name}"
  aws_region = "${var.aws_region}"
  lambda_arn = "${var.apex_function_serverless_url_shortener}"
}

module "dns" {
  source = "../modules/dns"

  domain_config     = "${var.domain_config}"
  cf_domain_name    = "${module.cloudfront.domain_name}"
  cf_hosted_zone_id = "${module.cloudfront.hosted_zone_id}"
}
