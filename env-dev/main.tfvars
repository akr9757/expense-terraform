env="dev"
kms_key_id = "arn:aws:kms:us-east-1:390844751090:key/df8fde32-64dd-43f1-a899-8d27a77e18a1"
project_name = "expense"
bastion_cidrs = ["172.31.35.166/32"]
acm_arn = "arn:aws:acm:us-east-1:390844751090:certificate/d2f79188-e254-40cb-b1d6-017948373f46"
zone_id = "Z03858273FGU51VSWPG4T"
prometheus_cidrs = ["172.31.21.254/32"]

vpc = {
  main = {
    vpc_cidr_block               = "10.20.0.0/21"
    public_subnets_cidr          = ["10.20.0.0/25", "10.20.0.128/25"]
    web_subnets_cidr             = ["10.20.1.0/25", "10.20.1.128/25"]
    app_subnets_cidr             = ["10.20.2.0/25", "10.20.2.128/25"]
    db_subnets_cidr              = ["10.20.3.0/25", "10.20.3.128/25"]
    az                           = ["us-east-1a", "us-east-1b"]
  }
} 

rds = {
  main = {
    allocated_storage    = 10
    db_name              = "expense"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    family               = "mysql5.7"
  }
}

# app = {
#   frontend = {
#     component          = "frontend"
#     instance_type      = "t3.micro"
#     instance_capacity  = 1
#     max_size           = 1
#     min_size           = 1
#     port_no            = 80
#   }
#   backend = {
#     component          = "backend"
#     instance_type      = "t3.micro"
#     instance_capacity  = 1
#     max_size           = 1
#     min_size           = 1
#     port_no            = 8080
#   }
# }


backend_port_no = 8080
backend_instance_capacity = 1
backend_instance_type = "t3.medium"

frontend_port_no = 80
frontend_instance_capacity = 1
frontend_instance_type = "t3.medium"
