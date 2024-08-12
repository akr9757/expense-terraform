module "vpc" {
  source = "./modules/vpc"
  for_each = var.vpc


  cidr_block           = lookup(each.value, "cidr_block" null)
  env                  = var.env
  public.subnet_cidr = lookup(each.value, "public.subnet_cidr" null)
}