data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
        }

    filter {
        name    = "virtualization-type"
        values  =["hvm"]
    }

    owners  = ["099720109477"]
}

data "aws_lb" "dsl_ghost_lb" {
  depends_on = [
    aws_lb.dsl_ghost_alb
  ]
}


resource "aws_launch_configuration" "dsl_ghost_lc" {
  name_prefix           = "dsl-ghost-lc"
  image_id = data.aws_ami.ubuntu.image_id
  security_groups = [aws_security_group.dsl_ghost_asg_sg.id]
  instance_type = var.ec2_instance_type

  user_data = templatefile("${path.module}/user_data/init_ghost.sh",
    {
      "endpoint" = aws_db_instance.dsl_ghost_rds.address,
      "database" = aws_db_instance.dsl_ghost_rds.name,
      "username" = aws_db_instance.dsl_ghost_rds.username,
      "password"  = var.mysql_password,
      "admin_url" = data.aws_lb.dsl_ghost_lb.dns_name,
      "url"       = data.aws_lb.dsl_ghost_lb.dns_name,
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dsl_ghost_asg" {
  name                 = "dsl-ghost-asg"
  launch_configuration = aws_launch_configuration.dsl_ghost_lc.name
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  vpc_zone_identifier  = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  # Associate the ASG with the Application Load Balancer target group.
  target_group_arns = [aws_lb_target_group.dsl_ghost_lb_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "dsl_ghost_asg_asp" {
  autoscaling_group_name = "dsl-ghost-asg"
  name = "dsl-ghost-asg-asp"
  policy_type = "PredictiveScaling"
  predictive_scaling_configuration {
    mode = "ForecastAndScale"
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label = aws_lb_target_group.dsl_ghost_lb_tg.id
      }
      predefined_scaling_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
        resource_label = aws_lb_target_group.dsl_ghost_lb_tg.id
      }
    }
  }
}

resource "aws_security_group" "dsl_ghost_asg_sg" {
  name        = "dsl-ghost-asg-sg"
  description = "Security group for the ghost instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow http traffic from the load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.dsl_ghost_lb_sg.id]
  }

  ingress {
    description = "Ingress rule for ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags,
    {
      "Name" : "dsl-ghost-asg-sg"
  })
}
