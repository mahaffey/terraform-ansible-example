# terraform-ansible-example

### Requirements
- terraform 0.12.9 or higher
- ansible 2.7.10 or higher
- python 3.7 or higher
- awscli 1.16.60 or higher
- AWS account
  - if MFA is enabled on the AWS account you will need a session token from STS

### Assumptions
- Using local terraform state instead of a remote state in a s3 bucket/dynamoDB table which we have IAM access to
- we tag our VPCs with `Name:<name>`, if no `vpc_name` is specified we will use the default VPC
- The default AMI is `Amazon Linux` for `us-east-1`
### Run
- Configure your awscli and fetch a session token and export it to your environment if necessary
- I would like to note that anisble does not do the cleanest catch of the terraform stdout and will display all ANSI color codes as opposed to parsing them
```
make install  # install dependencies
make plan     # terraform plan
make apply    # WARNING this has the terraform `auto_approve` flag on and will provision infrastructure
```
### Results
- Creation of AWS Resources:
  - Launch Template
  - EC2 Autoscaling Group
    - EC2s
    - ELBs
    - ENIs
    - etc
  - Elastic Load Balancer for the Autoscaling Group
  - Security Group and two rules (ingress/egress)
  - Route53 Recordset (if specified and if Zone exists for the RecordSet)
- These EC2s are accessible on the whitelisted CIDR (default 0.0.0.0/0) on port 80 and will host the simple html website written into the VM via the bootstrap scripts

### Ansible Variables and their Defaults
>Note: Ansible variables also contain all terraform variables prefixed in this manner: `tfvars_ami_id`

|             Variables               |            Description             |                    Default                |
|-------------------------------------|------------------------------------|-------------------------------------------|
| `terraform_asg_enabled`             | Role enabler for the playbook      | `True`                                    |
| `tf_apply`                          | If True tf `apply`, if False `plan`| `False`                                   |



tf_apply: false
### Terraform Variables and their Defaults
>Note: The weird formatting on maps and lists `' []'` and `' {}'` is due to the reasons outlined here (TL;DR typecasting in python): https://stackoverflow.com/questions/31969872/why-ansible-always-replaces-double-quotes-with-single-quotes-in-templates

|             Variables               |            Description             |                    Default                |
|-------------------------------------|------------------------------------|-------------------------------------------|
| `ami_id`                            | ID of AMI to search for            | `ami-0664dc4f358fc089c`                   |
| `aws_region`                        | AWS region                         | `us-east-1`                               |
| `tags`                              |A mapping of tags to assign         | `{}`                                      |
| `instance_type`                     | EC2 instance type                  | `t2.micro`                                |
| `instance_count_max`                | instance count max                 | `1`                                       |
| `instance_count_min`                | instance count min                 | `1`                                       |
| `route53_zone`                      | route53 zone for the dns           | `""`                                      |
| `route53_record`                    | route53 record for the dns         | `"{}"`                                    |
| `launch_template_prefix`            | Prefix for the launch template     | `"webserver"`                             |
| `security_group_name`               | Name for the ASG security group    | `"asg-test-sg"`                           |
| `whitelisted_CIDRs`                 | Allowed CIDR blocks for access     | `' ["0.0.0.0/0",]'`                       |
