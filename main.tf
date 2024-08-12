module "vpc" {
  source = "./modules/vpc"
  for_each = var.vpc

  cidr_block           = lookup(each.value, "cidr_block", null)
  env                  = var.env
  subnets_cidr         = lookup(each.value, "subnets_cidr", null)
  az         = lookup(each.value, "az", null)
}