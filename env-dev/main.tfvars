env="dev"

resource "aws_instance" "instances" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["973714476881"]
}