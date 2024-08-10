resource "aws_instance" "instances" {
  for_each                   = var.components
  ami                        = data.aws_ami.ami.id
  instance_type              = lookup(each.value, "instance_type", null)
  vpc_security_group_ids     = ["sg-06d14744e7a12dcaf"]

  tags = {
    Name = lookup(each.value, "name", null)
  }
}

resource "aws_route53_record" "record" {
  for_each = var.components
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "${lookup(each.value, "name", null)}-${var.env}.akrdevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances[lookup(each.value, "name", null)].private_ip]
}

