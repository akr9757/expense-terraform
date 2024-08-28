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
#   port_no             = lookup(lookup(var.app, "backend", null), "port_no", null)
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
#   port_no             = lookup(lookup(var.app, "frontend", null), "port_no", null)
#
#   bastion_cidrs       = var.bastion_cidrs
#   env                 = var.env
#   project_name        = var.project_name
#
#   sg_cidr_blocks      = lookup(lookup(var.vpc, "main", null), "public_subnets_cidr", null)
#   vpc_id              = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#   vpc_zone_identifier = lookup(lookup(module.vpc, "main", null), "web_subnets_ids", null)
# }

module "backend" {
  depends_on = [module.rds]
  source = "./modules/app"

  port_no          = var.backend_port_no
  bastion_cidrs     = var.bastion_cidrs
  component         = "backend"
  env               = var.env
  instance_capacity = var.backend_instance_capacity
  instance_type     = var.backend_instance_type
  project_name      = var.project_name
  sg_cidr_blocks    = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)
  vpc_id            = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  vpc_zone_identifier = lookup(lookup(module.vpc, "main", null), "app_subnets_ids", null)
  parameters        = ["arn:aws:ssm:us-east-1:975050250738:parameter/${var.env}.${var.project_name}.rds.*"]
  kms               = var.kms_key_id
}



module "frontend" {
  source = "./modules/app"

  port_no          = var.frontend_port_no
  bastion_cidrs     = var.bastion_cidrs
  component         = "frontend"
  env               = var.env
  instance_capacity = var.frontend_instance_capacity
  instance_type     = var.frontend_instance_type
  project_name      = var.project_name
  sg_cidr_blocks    = lookup(lookup(var.vpc, "main", null), "public_subnets_cidr", null)
  vpc_id            = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  vpc_zone_identifier = lookup(lookup(module.vpc, "main", null), "web_subnets_ids", null)
  parameters        = []
  kms               = var.kms_key_id
}


module "public-alb" {
  source = "./modules/alb"

  alb_name       = "public"
  internal       = false
  dns_name       = "frontend"

  project_name   = var.project_name
  env            = var.env
  certificate_arn = var.acm_arn
  zone_id        = var.zone_id

  sg_cidr_blocks = ["0.0.0.0/0"]
  subnets        = lookup(lookup(module.vpc, "main", null), "public_subnets_ids", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  target_group_arn = module.frontend.target_group_arn
}

module "private-alb" {
  source = "./modules/alb"

  alb_name       = "private"
  internal       = true
  dns_name       = "backend"

  certificate_arn = var.acm_arn
  project_name   = var.project_name
  env            = var.env
  zone_id        = var.zone_id

  sg_cidr_blocks = lookup(lookup(var.vpc, "main", null), "web_subnets_cidr", null)
  subnets        = lookup(lookup(module.vpc, "main", null), "app_subnets_ids", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  target_group_arn = module.backend.target_group_arn

}