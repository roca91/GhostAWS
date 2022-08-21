resource "aws_lb" "dsl_ghost_alb" {
  name               = "dsl-ghost-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dsl_ghost_lb_sg.id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  

  tags = merge(var.tags,
    {
      "Name" = "dsl-ghost-alb"
  })
}

resource "aws_lb_listener" "dsl_ghost_lb_listener" {
  load_balancer_arn = aws_lb.dsl_ghost_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dsl_ghost_lb_tg.arn
  }
}

resource "aws_lb_target_group" "dsl_ghost_lb_tg" {
  name                 = "dsl-ghost-lb-tg"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 180
  vpc_id               = module.vpc.vpc_id

  health_check {
    healthy_threshold = 3
    interval          = 10
  }

  tags = merge(var.tags,
    {
      "Name" = "dsl-ghost-lb-tg"
  })
}


resource "aws_security_group" "dsl_ghost_lb_sg" {
  name   = "dsl-ghost-sg-alb"
  description = "Security group for the Loadbalancer"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Accept http traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow any traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags,
    {
      "Name" = "dsl-ghost-alb-sg"
  })
}



#
/* resource "aws_acm_certificate" "dsl_ghost_cert" {
  domain_name       = data.aws_lb.dsl-ghost-lb.dns_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_acm_certificate_validation" "dsl_ghost_cert_validation" {
  certificate_arn = aws_acm_certificate.dsl_ghost_cert.arn
} */


/* data "aws_acm_certificate" "issued" {
  domain            = data.aws_lb.dsl-ghost-lb.dns_name
  statuses = [ "ISSUED" ]
} */

/* resource "aws_lb_listener" "dsl_ghost_lb_listener_https" {
  load_balancer_arn = aws_lb.dsl_ghost_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.dsl_ghost_cert_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dsl_ghost_lb_tg.arn
  }
} */
