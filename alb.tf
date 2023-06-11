data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
    filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "example" {
  name               = "example-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet.default.id
  security_groups    = [data.aws_security_group.default.id]
  tags               = var.tags
}

resource "aws_lb_target_group" "example" {
  name         = "example-target-group"
  port         = 80
  protocol     = "HTTP"
  vpc_id       = data.aws_vpc.default.id
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags         = var.tags
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_lb_target_group_attachment" "example" {
  count            = 3 # Specify the number of instances to attach
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.example[count.index].id
  port             = 80
}
