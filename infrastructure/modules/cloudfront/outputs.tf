output "domain_name" {
  value = "${aws_cloudfront_distribution.cf.domain_name}"
}

output "hosted_zone_id" {
  value = "${aws_cloudfront_distribution.cf.hosted_zone_id}"
}
