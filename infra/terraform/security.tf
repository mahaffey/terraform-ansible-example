resource "aws_security_group" "asg-sg" {
  name   = var.security_group_name
  vpc_id = data.aws_vpc.default.id
}

# Ingress Security Port 80
resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.asg-sg.id
  type              = "ingress"
  cidr_blocks       = var.whitelisted_CIDRs
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.asg-sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
