# acm

resource "aws_acm_certificate" "cert" {
  count             = "${var.base_domain != "" ? 1 : 0}"
  domain_name       = "${aws_route53_record.app.0.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  count   = "${var.base_domain != "" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.app.id}"
  name    = "${aws_acm_certificate.cert.0.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.0.domain_validation_options.0.resource_record_type}"
  ttl     = 60

  records = [
    "${aws_acm_certificate.cert.0.domain_validation_options.0.resource_record_value}",
  ]
}

resource "aws_acm_certificate_validation" "cert" {
  count           = "${var.base_domain != "" ? 1 : 0}"
  certificate_arn = "${aws_acm_certificate.cert.0.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.cert_validation.0.fqdn}",
  ]
}
