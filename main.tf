resource "aws_instance" "instances" {
  ami                        = data.aws_ami.ami.id
  instance_type              = "t3.micro"
  vpc_security_group_ids     = ["vpc-016b04b871ea2362c"]

  tags = {
    Name = "frontend"
  }
}

