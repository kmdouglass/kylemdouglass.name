resource "aws_s3_bucket" "kylemdouglass_name_bucket" {
  bucket = var.kylemdouglass_name_bucket
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name      = "kylemdouglass.name Bucket"
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "kylemdouglass_name_bucket_policy_document" {
  statement {
    sid = "CloudFrontGetObject"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.kylemdouglass_name_bucket.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin-access-identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "kylemdouglass_name_bucket_policy" {
  bucket = aws_s3_bucket.kylemdouglass_name_bucket.id
  policy = data.aws_iam_policy_document.kylemdouglass_name_bucket_policy_document.json
}

resource "aws_s3_bucket" "kylemdouglass_name_distribution_logs_bucket" {
  bucket = var.kylemdouglass_name_distribution_logs_bucket
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name      = "kylemdouglass.name Distribution Logs"
    Terraform = "true"
  }
}
