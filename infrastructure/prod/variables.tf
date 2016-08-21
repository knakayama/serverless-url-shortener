variable "aws_region" {}

variable "apex_function_serverless_url_shortener" {}

variable "name" {
  default = "serverless-url-shortener"
}

variable "s3_config" {
  default = {
    index = "index.html"
  }
}

variable "cf_config" {
  default = {
    price_class = "PriceClass_200"
    acm_arn     = "_ACM_ARN_"
  }
}

variable "domain_config" {
  default = {
    domain     = "_YOUR_DOMAIN_"
    sub_domain = "_YOUR_SUB_DOMAIN_"
  }
}
