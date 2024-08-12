variable "vpc_cidr_block" {}
variable "env" {}
variable "public_subnets_cidr" {}
variable "project_name" {
  default = "expense"
}
variable "az" {}
variable "web_subnets_cidr" {}
variable "app_subnets_cidr" {}
variable "db_subnets_cidr" {}
