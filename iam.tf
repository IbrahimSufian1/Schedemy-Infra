resource "aws_iam_role" "ec2_role" {
  name = "schedemy-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement =[{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "schedemy-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

}
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "schedemy-s3-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.app_bucket.arn,
          "${aws_s3_bucket.app_bucket.arn}/*"
        ]
      }
    ]
  })
}
