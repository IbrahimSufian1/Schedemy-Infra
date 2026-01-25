#Load Balancer creation
resource "aws_lb" "main_lb" {
name = "schedemy-alb"
internal = false #publicly accessible
load_balancer_type = "application"
security_groups = [aws_security_group.alb_sg.id]  #follow the security rules
subnets = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]#ALB in both subnets
tags = {Name = "schedemy-alb"}
}

#Target Group creation
resource "aws_lb_target_group" "app_tg" {
  name     = "schedemy-app-tg"
  port     = 8080 #spring boot application port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
#HEALTH CHECK CONFIGURATION
#here we use the actuator 
  health_check {
    path                = "/"
    interval = 30 #check every seconds
    timeout             = 5 #if no response in 5 seconds consider unhealthy
    healthy_threshold   = 2 #after 2 successful checks consider healthy
    unhealthy_threshold = 5 #after 5 failed checks consider unhealthy
    matcher             = "200,404" #expecting HTTP 200 response
    protocol = "HTTP"
  }
}

# HTTPS Listener (إضافة بورت 443 للربط مع Amplify)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-north-1:016850833530:certificate/caded00b-a558-4e95-87c1-ce1ab29ed412"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# HTTP Listener (تعديل بورت 80 للتحويل إلى HTTPS)
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main_lb.arn
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