env="dev"
kms_key_id = "arn:aws:kms:us-east-1:975050250738:key/581c3619-7ba5-4a58-833d-0a657d809e15"
project_name = "expense"
bastion_cidrs = ["172.31.44.215/32"]
acm_arn = "arn:aws:acm:us-east-1:975050250738:certificate/f97bfe82-675b-4b88-8d19-5154caff5840"
zone_id = "Z04275581JIKR4XEVM94K"
prometheus_cidrs = ["172.31.92.76/32"]

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
backend_instance_type = "t3.micro"

frontend_port_no = 80
frontend_instance_capacity = 1
frontend_instance_type = "t3.micro"
