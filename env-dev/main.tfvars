env="dev"
kms_key_id = "arn:aws:kms:us-east-1:975050250738:key/581c3619-7ba5-4a58-833d-0a657d809e15"
project_name = "expense"
bastion_cidrs = ["172.31.44.215/32"]

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

app = {
#   frontend = {
#     name               = "frontend"
#     instance_type      = "t3.micro"
#     instance_capacity  = 1
#     max_size           = 1
#     min_size           = 1
#     port_no            = 80
#   }
  backend = {
    name               = "backend"
    instance_type      = "t3.micro"
    instance_capacity  = 1
    max_size           = 1
    min_size           = 1
    port_no            = 8080
  }

}
