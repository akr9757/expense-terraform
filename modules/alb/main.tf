resource "aws_security_group" "main" {
  name        = "${ local.name }-sg"
  description = "${ local.name }-sg"
  vpc_id      = var.vpc_id


  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidr_blocks
    description      = "HTTP"
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidr_blocks
    description      = "HTTPS"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${ local.name }-sg"
  }
}

resource "aws_lb" "main" {
  name               = local.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets


  tags = {
    Name = local.name
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}

resource "aws_lb_listener" "www" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = "${var.dns_name}-${var.env}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_lb.main.dns_name]
}


