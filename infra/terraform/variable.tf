variable "ami_id" {
  type        = string
  description = "ID of AMI to search for"
  # amazon linux us-east1
  default = "ami-0664dc4f358fc089c"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "tags" {
  description = "A mapping of tags to assign"
  default     = {}
  type        = map
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_count_max" {
  type        = number
  description = "instance count max"
  default     = 1
}

variable "instance_count_min" {
  type        = string
  description = "instance count min"
  default     = 1
}

variable "route53_zone" {
  type        = string
  description = "route53 zone for the DNS"
  default     = ""
}

variable "route53_record" {
  type        = string
  description = "route53 record for the DNS"
}

variable "launch_template_prefix" {
  type        = string
  description = "Prefix for the launch template"
  default     = "webserver"
}

variable "security_group_name" {
  type        = string
  description = "Name for the ASG security group"
  default     = "asg-test-sg"
}

variable "whitelisted_CIDRs" {
  type        = list
  description = "Allowed CIDR blocks for access"
  default     = ["0.0.0.0/0"]
}
