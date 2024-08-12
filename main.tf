module "vpc" {
  source = "./modules/vpc"
  for_each = var.vpc

  vpc_cidr_block                = lookup(each.value, "vpc_cidr_block", null)
  public_subnets_cidr           = lookup(each.value, "public_subnets_cidr", null)
  web_subnet_cidr               = lookup(each.value, "web_subnets_cidr", null)
  app_subnet_cidr               = lookup(each.value, "app_subnets_cidr", null)
  db_subnet_cidr               = lookup(each.value, "db_subnets_cidr", null)
  env                           = var.env
  az                            = lookup(each.value, "az", null)
}