# CloudFront Distribution for Schedemy Backend API
resource "aws_cloudfront_distribution" "backend_cdn" {
  origin {
    domain_name = aws_lb.main_lb.dns_name
    origin_id   = "Schedemy-ALB-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" 
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Global CDN for Schedemy API"
  
  aliases = ["api.htufolio.com"]

  # Caching Behavior
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "Schedemy-ALB-Origin"

    forwarded_values {
      query_string = true
      headers      = ["*"] # Forward all headers to support CORS and authentication
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https" 
    min_ttl                = 0
    default_ttl            = 0 # because it's an API, we want fresh data
    max_ttl                = 0
  }

  #Global Access
  restrictions {
    geo_restriction {
      restriction_type = "none" # Allow access from all locations
    }
  }

  # SSL Certificate 
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:016850833530:certificate/a79c16a1-8863-4d0d-8a06-7e4cad969842" 
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "Schedemy-CloudFront"
  }
}

#CloudFront Domain Name Output
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.backend_cdn.domain_name
  description = "The domain name of the CloudFront distribution"
}