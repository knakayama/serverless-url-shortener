resource "aws_route53_zone" "dns" {
  name = "${var.domain_config["domain"]}"
}

resource "aws_route53_record" "cf" {
  zone_id = "${aws_route53_zone.dns.zone_id}"
  name    = "${var.domain_config["sub_domain"]}"
  type    = "A"

  alias {
    name                   = "${var.cf_domain_name}"
    zone_id                = "${var.cf_hosted_zone_id}"
    evaluate_target_health = false
  }
}
