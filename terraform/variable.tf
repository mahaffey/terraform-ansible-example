variable "ami_id" {
  type        = "string"
  description = "ID of AMI to search for"
  # amazon linux us-east1
  default = "ami-0664dc4f358fc089c"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "us-east1"
}

variable "tags" {
  description = "A mapping of tags to assign"
  default     = {}
  type        = "map"
}

variable "instance_type" {
  type        = "string"
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_count_max" {
  type        = "number"
  description = "instance count max"
  default     = 1
}

variable "instance_count_min" {
  type        = "string"
  description = "instance count min"
  default     = 1
}

variable "create_dns_record" {
  type        = "boolean"
  description = "whether or not to crate a DNS record"
  default     = false
}

variable "route53_zone" {
  type        = "string"
  description = "route53 zone for the dns"
}

variable "route53_record" {
  type        = "string"
  description = "route53 zone for the dns"
}

variable "launch_template_prefix" {
  type        = "string"
  description = "Prefix for the launch template"
}

variable "security_group_name" {
  type        = "string"
  description = "Name for the ASG security group"
}

variable "whitelisted_CIDRs" {
  type        = "list"
  description = "Allowed CIDR blocks for access"
  default     = ["0.0.0.0/0"]
}
