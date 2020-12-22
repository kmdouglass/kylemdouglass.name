resource "aws_iam_user" "kylemdouglass_name" {
  name = "kylemdouglass-name"

  tags = {
    "Name"      = "kylemdouglass-name"
    "Terraform" = "true"
  }
}

resource "aws_iam_user" "github_actions" {
  name = "github-actions"

  tags = {
    "Name"      = "github-actions"
    "Terraform" = "true"
  }
}

resource "aws_iam_role" "kylemdouglass_name_bucket_ops" {
  name               = "kylemdouglass-name-bucket-ops"
  assume_role_policy = data.aws_iam_policy_document.kylemdouglass_name_bucket_ops_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kylemdouglass_name_bucket_ops" {
  role       = aws_iam_role.kylemdouglass_name_bucket_ops.name
  policy_arn = aws_iam_policy.kylemdouglass_name_bucket_ops_policy.arn
}

resource "aws_iam_policy" "kylemdouglass_name_bucket_ops_policy" {
  name        = "kylemdouglass-name-bucket-ops-policy"
  description = "Policy for reading, writing, and deleting files in the bucket hosting kylemdouglass.name"

  policy = data.aws_iam_policy_document.kylemdouglass_name_bucket_ops_policy_document.json
}

data "aws_iam_policy_document" "kylemdouglass_name_bucket_ops_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.kylemdouglass_name_bucket}",
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.kylemdouglass_name_bucket}/*",
    ]
  }
}

data "aws_iam_policy_document" "kylemdouglass_name_bucket_ops_assume_role_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_user.kylemdouglass_name.arn,
        aws_iam_user.github_actions.arn
      ]
    }
  }
}
