provider "aws" {
  region = var.aws_region
}

data "template_file" "user_data" {
  template = file("./bootstrap.sh")
}

#######
# ASG #
#######

resource "aws_launch_template" "this" {
  name_prefix   = "${var.launch_template_prefix}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.asg-sg.id]

  iam_instance_profile {
    name = "mahaffey"
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name             = "ASG-${aws_launch_template.this.name}"
  max_size         = var.instance_count_min
  min_size         = var.instance_count_max
  desired_capacity = var.instance_count_min

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  vpc_zone_identifier = data.aws_subnet_ids.this.ids

  default_cooldown          = 180
  health_check_grace_period = 180
  health_check_type         = "ELB"

  termination_policies = [
    "OldestLaunchTemplate",
  ]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "ASG-${aws_launch_template.this.name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

###################
# Load Balancers #
##################

resource "aws_lb" "this" {
  name     = "${aws_launch_template.this.name}-lb"

  subnets = data.aws_subnet_ids.this.ids

  load_balancer_type = "application"

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name        = "${aws_launch_template.this.name}-lb-target"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    port     = "traffic-port"
    protocol = "TCP"
  }

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "TCP"
}

###########
# Route53 #
###########

resource "aws_route53_record" "this" {
  count = var.route53_record != "" ? 1 : 0 # cast truthy/falsy value to int for conditional creation

  zone_id = data.aws_route53_zone.this[0].id
  name    = var.route53_record
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
