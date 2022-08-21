module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = var.vpc_name
  cidr             = var.vpc_cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets

  tags = var.tags
}