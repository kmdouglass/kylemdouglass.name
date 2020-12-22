resource "aws_acm_certificate" "certificate" {
  provider = aws.us-east-1

  domain_name               = "kylemdouglass.name"
  subject_alternative_names = ["*.kylemdouglass.name"]
  validation_method         = "DNS"

  tags = {
    Name      = "kylemdouglass.name"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  provider        = aws.us-east-1
  certificate_arn = aws_acm_certificate.certificate.arn
}
