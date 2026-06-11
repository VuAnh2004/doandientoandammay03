# ============================================
# alb.tf
# ============================================

# Application Load Balancer
resource "aws_lb" "web_alb" {
  name               = "webdt3-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [
    data.aws_subnet.subnet_1.id,
    data.aws_subnet.subnet_2.id,
  ]

  tags = { Name = "webdt3-alb" }
}

# Target Group trỏ vào EC2 web server
resource "aws_lb_target_group" "web_tg" {
  name     = "webdt3-tg"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    port                = "9000"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 10
    matcher             = "200,302"  # ← chấp nhận cả redirect
  }

  tags = { Name = "webdt3-tg" }
}

# Gắn EC2 vào Target Group
resource "aws_lb_target_group_attachment" "web_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server.id
  port             = 9000
}

# Listener HTTP port 80 → forward vào Target Group
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}