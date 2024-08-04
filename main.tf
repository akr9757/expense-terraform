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

resource "aws_route53_record" "www" {
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "frontend-dev.akrdevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances.private_ip]
}