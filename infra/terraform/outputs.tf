output "route53_record" {
  value = "${var.route53_record != "" ? aws_route53_record.this[0].name : ""}"
}
