# tf-e3-vpc-module
Learn Terraform Exercise using 3rd party AWS module

[![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

Goals of this Exercise:

- [ ] Learn to use 3rd party AWS terraform modules

## 🚧 -> 🚀

Terraform workflow:

```
terraform fmt
terraform init
terraform validate
terraform plan -out my-tf-plan.tfplan
terraform apply my-tf-plan.tfplan
terraform destroy
```

## Thirdparty VPC Module

In this exercise, we use the AWS VPC Module crafted by Anton Babenko.

https://registry.terraform.io/modules/terraform-aws-modules/vpc/

We are using the VPC module 4 times

- VPC E3a with fixed EIPs, single NAT per VPC
- VPC E3b with all networks, single NAT
- VPC E3c with public reachable Database Network
- VPC E3d with IPv6

## Debug and Enhancements

- [ ] Checkout Git Branch `fixme_1` and try to fix the setup
- [ ] Checkout Git Branch `fixme_2` and try to fix the setup
- [ ] create a new main.tf with only 1 VPC, with public_subnet, private_subnet, intra_subnets, flowlogs, and as a bonus private endpoints (ssm, ec2, kms)



---

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg