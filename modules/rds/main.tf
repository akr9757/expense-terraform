resource "aws_db_subnet_group" "main" {
  name       = "${ local.name }-sg"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${ local.name }-sg"
  }
}

resource "aws_security_group" "main" {
  name        = "${ local.name }-stg"
  description = "${ local.name }-stg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "-1"
    cidr_blocks      = var.sg_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${ local.name }-stg"
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "${ local.name }-pg"
  family = var.family
}


resource "aws_db_instance" "rds" {
  identifier           = "${ local.name }-rds"
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = data.aws_ssm_parameter.username.value
  password             = data.aws_ssm_parameter.password.value
  parameter_group_name = aws_db_parameter_group.main.name
  skip_final_snapshot  = true
  storage_encrypted    = true
  kms_key_id           = var.kms_key_id
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
}