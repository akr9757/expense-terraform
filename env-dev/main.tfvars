env="dev"

variable "components" {
  main = {
    frontend = {
      name = "frontend"
      instance_type = "t3.micro"
    }
    backend = {
      name = "backend"
      instance_type = "t3.micro"
    }
    mysql = {
      name = "mysql"
      instance_type = "t3.micro"
    }
  }
}