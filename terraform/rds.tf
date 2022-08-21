resource "aws_db_instance" "dsl_ghost_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  multi_az               = "true"
  engine_version         = var.mysql_engine_version
  instance_class         = var.mysql_instance_class
  db_name                = var.mysql_name
  username               = var.mysql_username
  password               = var.mysql_password
  db_subnet_group_name   = aws_db_subnet_group.dsl_mysql_subnet_group.name
  parameter_group_name   = var.mysql_parameter_group_name
  vpc_security_group_ids = [aws_security_group.dsl_mysql_sg.id]
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "dsl_mysql_subnet_group" {
  name       = "main"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  tags = merge(var.tags,
    {
      "Name" = "dsl-mysql-subnet-group"
  })
}

resource "aws_security_group" "dsl_mysql_sg" {
  name        = "dsl_mysql_sg"
  description = "dsl_mysql_sg"
  vpc_id      = module.vpc.vpc_id


  ingress {
    description = "Allow mysql traffic from the asg members"
    from_port = 3306
    to_port   = 3306
    protocol  = "TCP"
    security_groups = [aws_security_group.dsl_ghost_asg_sg.id]
  }

  egress {
    description = "Allow mysql traffic to the asg members"
    from_port = 3306
    to_port   = 3306
    protocol  = "TCP"
    security_groups = [aws_security_group.dsl_ghost_asg_sg.id]
  }

  tags = merge(var.tags,
    {
      "Name" = "dsl-mysql-subnet-group"
  })
}