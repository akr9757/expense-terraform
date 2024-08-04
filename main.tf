resource "aws_instance" "instances" {
  ami                        = data.aws_ami.ami.id
  instance_type              = "t3.micro"
  vpc_security_group_ids     = ["vpc-016b04b871ea2362c"]

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