data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_route53_zone" "this" {
  count = var.route53_zone != "" ? 1 : 0
  name = var.route53_zone
}
