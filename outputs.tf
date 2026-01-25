output "application_url" {
    description = "The URL of the application load balancer"
    value       = aws_lb.main_lb.dns_name
    }