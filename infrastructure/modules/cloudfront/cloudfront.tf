resource "aws_cloudfront_distribution" "cf" {
  comment          = "${var.name}-cf"
  price_class      = "${var.cf_config["price_class"]}"
  aliases          = ["${var.domain_config["sub_domain"]}.${var.domain_config["domain"]}"]
  retain_on_delete = true
  enabled          = true

  origin {
    domain_name = "${var.s3_website_endpoint}"
    origin_id   = "OriginRedirect"
    origin_path = "/u"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "SSLv3"]
    }
  }

  origin {
    domain_name = "${var.s3_website_endpoint}"
    origin_id   = "OriginAdmin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "SSLv3"]
    }
  }

  origin {
    domain_name = "${var.api_gateway_id}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "OriginAPIGW"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "SSLv3"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "OriginRedirect"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  cache_behavior {
    path_pattern           = "/admin/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "OriginAdmin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  cache_behavior {
    path_pattern           = "/prod/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "OriginAPIGW"
    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.cf_config["acm_arn"]}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "SSLv3"
  }
}
