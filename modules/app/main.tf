resource "aws_launch_template" "main" {
  name_prefix   = "${local.name}-alt"
  image_id      = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.new.id]

  tags = {
    Name = "${local.name}-alt"
  }
}

resource "aws_security_group" "new" {
  name        = "${ local.name }-sg"
  description = "${ local.name }-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.bastion_cidrs
    description      = "SSH"
  }

  ingress {
    from_port        = var.port_no
    to_port          = var.port_no
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidr_blocks
    description      = "APPPORT"
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

resource "aws_autoscaling_group" "main" {
  desired_capacity   = var.instance_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier


  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${ local.name }"
  }
}