# ---------------------------------------------------------------------------------------------------------------------
# ¦ REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  # This module is only being tested with Terraform 1.2.0 and newer.
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws" # equals to registry.terraform.io/hashicorp/aws
      version               = "~> 4.16"
      configuration_aliases = []
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ DATA
# ---------------------------------------------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ VPC Part A (fixed EIP, single nat)
# ---------------------------------------------------------------------------------------------------------------------

# keep external NAT IPv4 adress
# -> https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.2#external-nat-gateway-ips

resource "aws_eip" "nat" {
  count = 1
  vpc   = true
}

module "vpc_e3a" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-e3a-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = true
  reuse_nat_ips          = true             # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids    = aws_eip.nat.*.id # <= IPs specified here as input to the module

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Exercise    = "E3"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ VPC Part B (all networks, single NAT)
# ---------------------------------------------------------------------------------------------------------------------

module "vpc_e3b" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-e3b-vpc"
  cidr = "10.1.0.0/16"

  azs                 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_subnets    = ["10.1.21.0/24", "10.1.22.0/24"]
  elasticache_subnets = ["10.1.31.0/24", "10.1.32.0/24"]
  private_subnets     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
  redshift_subnets    = ["10.1.41.0/24", "10.1.42.0/24"]
  intra_subnets       = ["10.1.51.0/24", "10.1.52.0/24", "10.1.53.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Exercise    = "E3b"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ VPC Part C
# ---------------------------------------------------------------------------------------------------------------------

module "vpc_e3c" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-e3c-vpc"
  cidr = "10.2.0.0/16"

  azs              = ["eu-west-1a", "eu-west-1b"]
  database_subnets = ["10.2.21.0/24", "10.2.22.0/24"]
  public_subnets   = ["10.2.101.0/24", "10.2.102.0/24"]

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Exercise    = "E3c"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  region = "eu-west-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ VPC Part D (using locals)
# ---------------------------------------------------------------------------------------------------------------------

module "vpc_e3d" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-e3d-vpc"
  cidr = "10.3.0.0/16"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets  = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
  public_subnets   = ["10.3.101.0/24", "10.3.102.0/24", "10.3.103.0/24"]
  database_subnets = ["10.3.103.0/24", "10.3.104.0/24", "10.3.105.0/24"]

  enable_nat_gateway = false

  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true

  private_subnet_assign_ipv6_address_on_creation = false

  public_subnet_ipv6_prefixes   = [0, 1, 2]
  private_subnet_ipv6_prefixes  = [3, 4, 5]
  database_subnet_ipv6_prefixes = [6, 7, 8]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Exercise    = "E3d"
  }
}