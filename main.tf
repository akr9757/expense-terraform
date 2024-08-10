resource "aws_instance" "instances" {
  for_each                = var.components
  ami                     = data.aws_ami.ami.image_id
  instance_type           = "t3.micro"
  vpc_security_group_ids  = ["sg-06d14744e7a12dcaf"]

  tags = {
    Name = lookup(each.value, "name", null)
  }
}

resource "aws_route53_record" "main" {
  for_each                = var.components
  zone_id                 = "Z04275581JIKR4XEVM94K"
  name                    = lookup(each.value, "name", null)
  type                    = "A"
  ttl                     = 30
  records                 = [aws_instance.instances[each.key].private_ip]
}
