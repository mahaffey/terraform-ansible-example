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
- The default AMI is `Amazon Linux` for `us-east1`
### Run
- Configure your awscli and fetch a session token if necessary
```
make install
make
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
