module "vpc" {
  source = "./modules/vpc"

  for_each                       = var.vpc
  vpc_cidr_block                 = lookup(each.value, "vpc_cidr_block", null)
  public_subnets_cidr            = lookup(each.value, "public_subnets_cidr", null)
  web_subnets_cidr               = lookup(each.value, "web_subnets_cidr", null)
  app_subnets_cidr               = lookup(each.value, "app_subnets_cidr", null)
  db_subnets_cidr                = lookup(each.value, "db_subnets_cidr", null)
  env                            = var.env
  az                             = lookup(each.value, "az", null)
}


module "rds" {
  source   = "./modules/rds"

  for_each           = var.rds
  allocated_storage = lookup(each.value, "allocated_storage", null)
  db_name           = lookup(each.value, "db_name", null)
  engine            = lookup(each.value, "engine", null)
  engine_version    = lookup(each.value, "engine_version", null)
  family            = lookup(each.value, "family", null)
  instance_class    = lookup(each.value, "instance_class", null)

  kms_key_id        = var.kms_key_id
  env               = var.env
  project_name      = var.project_name

  subnet_ids        = lookup(lookup(module.vpc, "main", null), "db_subnets_ids", null)
  vpc_id            = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_cidr_blocks    = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)
}

# module "backend" {
#   source = "./modules/app"
#
#   for_each            = var.app
#   component           = lookup(lookup(var.app, "backend", null), "component", null)
#   instance_capacity   = lookup(lookup(var.app, "backend", null), "instance_capacity", null)
#   instance_type       = lookup(lookup(var.app, "backend", null), "instance_type", null)
#   max_size            = lookup(lookup(var.app, "backend", null), "max_size", null)
#   min_size            = lookup(lookup(var.app, "backend", null), "min_size", null)
#   port_no             = lookup(lookup(var.app, "backend", null), "instance_capacity", null)
#
#   bastion_cidrs       = var.bastion_cidrs
#   env                 = var.env
#   project_name        = var.project_name
#
#   sg_cidr_blocks      = lookup(lookup(var.vpc, "main", null), "web_subnets_cidr", null)
#   vpc_id              = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#   vpc_zone_identifier = lookup(lookup(module.vpc, "main", null), "app_subnets_ids", null)
# }

# module "frontend" {
#   source = "./modules/app"
#
#   for_each            = var.app
#   component           = lookup(lookup(var.app, "frontend", null), "component", null)
#   instance_capacity   = lookup(lookup(var.app, "frontend", null), "instance_capacity", null)
#   instance_type       = lookup(lookup(var.app, "frontend", null), "instance_type", null)
#   max_size            = lookup(lookup(var.app, "frontend", null), "max_size", null)
#   min_size            = lookup(lookup(var.app, "frontend", null), "min_size", null)
#   port_no             = lookup(lookup(var.app, "frontend", null), "instance_capacity", null)
#
#   bastion_cidrs       = var.bastion_cidrs
#   env                 = var.env
#   project_name        = var.project_name
#
#   sg_cidr_blocks      = lookup(lookup(var.vpc, "main", null), "public_subnets_cidr", null)
#   vpc_id              = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#   vpc_zone_identifier = lookup(lookup(module.vpc, "main", null), "web_subnets_ids", null)
# }

# module "public-alb" {
#   source = "./modules/alb"
#
#   alb_name       = "public"
#   internal       = false
#   sg_cidr_blocks = ["0.0.0.0/0"]
#
#   project_name   = var.project_name
#   env            = var.env
#   certificate_arn = var.acm_arn
#
#   subnets        = lookup(lookup(module.vpc, "main", null), "public_subnets_ids", null)
#   vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#   target_group_arn = module.frontend.target_group_arn
# }

# module "private-alb" {
#   source = "./modules/alb"
#
#   alb_name       = "private"
#   internal       = true
#   sg_cidr_blocks = lookup(lookup(var.vpc, "main", null), "web_subnets_cidr", null)
#
#   certificate_arn = var.acm_arn
#   project_name   = var.project_name
#   env            = var.env
#
#   subnets        = lookup(lookup(module.vpc, "main", null), "app_subnets_ids", null)
#   vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#   target_group_arn = module.backend.target_group_arn
# }