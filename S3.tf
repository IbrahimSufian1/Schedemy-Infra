resource "aws_s3_bucket" "app_bucket" {
  bucket        = "ibrahim-schedemy-artifacts-unique" 
  force_destroy = true 

  tags = {
    Name        = "Schedemy Artifacts Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_block" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.id
}