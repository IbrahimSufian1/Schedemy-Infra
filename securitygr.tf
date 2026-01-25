#1 ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "schedemy-alb-sg"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = aws_vpc.main.id
 # allow_all_outbound = true
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

# Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"# all protocols
        cidr_blocks = ["0.0.0.0/0"]
}
tags = {Name = "alb-security-group"}
}

#2 App Server SG
resource "aws_security_group" "app_sg" {
  name        = "schedemy-app-sg"
  description = "Allow traffic Only from the ALB and SSH"
  vpc_id      = aws_vpc.main.id
 # server accepts traffic from  ALB ONLY
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]#only from ALB
}
#SSh access fr
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow SSH from anywhere
}

# Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
}
tags = {Name = "app-server-security-group"}
}