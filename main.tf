module "vpc" {
  source = "./modules/vpc"
  for_each = var.vpc

  cidr_block   = lookup(each.value, "cidr_block", null)
  env          = var.env
  project_name = var.project_name
}