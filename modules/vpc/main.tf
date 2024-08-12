resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block

  tags = {
    Name ="${var.project_name}-${var.env}-vpc"
  }
}

resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
  auto_accept = true
}



# resource "aws_subnet" "main" {
#   count      = length(var.public.subnet_cidr)
#   vpc_id     = aws_vpc.main.id
#   cidr_block = element(var.public.subnet_cidr, count.index)
#
#   tags = {
#     Name = "public-${count.index+1}"
#   }
# }