resource "aws_s3_bucket" "terraform-state" {
  bucket        = var.bucket
  acl           = "private"
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    "Name"      = "Terraform state"
    "Terraform" = "true"
  }
}

resource "aws_dynamodb_table" "terraform-state-lock" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    "Name"      = "Terraform state locks"
    "Terraform" = "true"
  }
}
