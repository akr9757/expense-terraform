env="dev"

vpc = {
  main = {
    vpc_cidr_block              = "10.20.0.0/21"
    public_subnets_cidr         = ["10.20.0.0/25", "10.20.0.128/25"]
    az                          = ["us-east-1a", "us-east-1b"]
    web_subnet_cidr             = ["10.20.1.0/25", "10.20.1.128/25"]
    app_subnet_cidr             = ["10.20.2.0/25", "10.20.2.128/25"]
    db_subnet_cidr              = ["10.20.3.0/25", "10.20.3.128/25"]
  }
}

