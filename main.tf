resource "aws_instance" "instances" {
  ami                        = data.aws_ami.ami.id
  instance_type              = "t3.micro"
  vpc_security_group_ids     = [aws_security_group.allow-all.id]

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "record" {
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "frontend-dev.akrdevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances.private_ip]
}

resource "aws_security_group" "allow-all" {
  name        = "allow-all"
  description = "Allow-all"
  vpc_id      = "vpc-016b04b871ea2362c"

  tags = {
    Name = "allow_tls"
  }
}