resource "aws_instance" "instances" {
  for_each = var.components
  ami                        = data.aws_ami.ami.id
  instance_type              = each.value["instance_type"]
  vpc_security_group_ids     = ["sg-06d14744e7a12dcaf"]

  tags = {
    Name = each.value["name"]
  }
}

resource "aws_route53_record" "record" {
  for_each = var.components
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "${each.value["name"]}-${var.env}.akrdevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances[each.value["name"]].private_ip]
}

