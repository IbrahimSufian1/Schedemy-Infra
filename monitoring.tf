# Create SNS Topic
resource "aws_sns_topic" "alerts" {
  name =  "schedemy-system-topic"
}
# Create SNS Topic Subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "ibraheemsufian441@gmail.com"
}
# Create CloudWatch Alarm for High CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name = "Schedemy-High-Cpu-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2 #number of periods to evaluate
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300 #5 minutes
  statistic = "Average"
  threshold = "80" #80 percent going to trigger alarm
  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn] #actions to execute when alarm goes to OK state
  #Set dimensions to monitor specific Auto Scaling Group
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}
# Create CloudWatch Alarm for Unhealthy Hosts in Target Group
resource "aws_cloudwatch_metric_alarm" "unhealthy_host_alarm" {
  alarm_name = "Schedemy-Unhealthy-Host-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1 #number of periods to evaluate
  metric_name = "UnhealthyHostCount"
  namespace = "AWS/ApplicationELB"
  period = 60 
  statistic = "Average"
  threshold = "0" #if more than 0 unhealthy hosts, trigger alarm
  alarm_description = "This metric monitors the number of unhealthy hosts in the target group"
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn] #actions to execute when alarm goes to OK state
  #Set dimensions to monitor specific Target Group
  dimensions = {
    TargetGroup = aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = aws_lb.main_lb.arn_suffix
  }
}
# Create CloudWatch Alarm for ALB 5xx Errors
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name = "Schedemy-ALB-5xx-Error"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name =  "HTTPCode_ELB_5XX_Count"
  namespace = "AWS/ApplicationELB"
  period = "60"
  statistic = "Sum"
  threshold = "1"
  alarm_description = "Alarm when ALB receives more than 1 HTTP 5xx error in 1 minute"
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn]
  dimensions = {
    LoadBalancer =aws_lb.main_lb.arn_suffix
  }
}
# Create CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "Schedemy-System-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${aws_autoscaling_group.app_asg.name}" ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-north-1"
          title  = "CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${aws_lb.main_lb.arn_suffix}" ]
          ]
          period = 60
          stat   = "Sum"
          region = "eu-north-1"
          title  = "Request Count"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${aws_lb.main_lb.arn_suffix}" ]
          ]
          period = 60
          stat   = "Average"
          region = "eu-north-1"
          title  = "Latency"
        }
      }
    ]
  })
}