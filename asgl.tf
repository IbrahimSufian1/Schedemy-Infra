#launch template creation
resource "aws_launch_template" "app_lt" {
    name_prefix = "schedemy-lt-"   
    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name

    iam_instance_profile {
      name = aws_iam_instance_profile.ec2_profile.name
    }
    network_interfaces {
        associate_public_ip_address = true
        security_groups = [aws_security_group.app_sg.id]
    }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo systemctl daemon-reload
              sudo systemctl enable --now schedemy
              EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {Name = "schedemy-server"}
  }
  }
#Auto Scaling Group creation
resource "aws_autoscaling_group" "app_asg" {
    name = "schedemy-asg"
    desired_capacity = 2#desired number of instances
    max_size = 4
    min_size = 2
    vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    target_group_arns = [aws_lb_target_group.app_tg.arn]#direct ASG to the LB
  
   launch_template {
     id = aws_launch_template.app_lt.id
     version = "$Latest"
   }
   health_check_type = "ELB"
   health_check_grace_period = 300 #5 minutes grace period for app to start
}