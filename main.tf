module "vpc" {
  source = "./modules/vpc"
  for_each = var.vpc

  vpc_cidr_block                = lookup(each.value, "vpc_cidr_block", null)
  public_subnets_cidr           = lookup(each.value, "public_subnets_cidr", null)
  web_subnets_cidr               = lookup(each.value, "web_subnets_cidr", null)
  app_subnets_cidr               = lookup(each.value, "app_subnets_cidr", null)
  db_subnets_cidr               = lookup(each.value, "db_subnets_cidr", null)
  env                           = var.env
  az                            = lookup(each.value, "az", null)
}


# module "rds" {
#   source   = "./modules/rds"
#   for_each = var.rds
#
#   allocated_storage = lookup(each.value, "allocated_storage", null)
#   db_name           = lookup(each.value, "db_name", null)
#   engine            = lookup(each.value, "engine", null)
#   engine_version    = lookup(each.value, "engine_version", null)
#   family            = lookup(each.value, "family", null)
#   instance_class    = lookup(each.value, "instance_class", null)
#   kms_key_id        = var.kms_key_id
# }