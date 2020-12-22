variable "bucket" {
  description = "AWS S3 bucket to use for the Terraform remote state"
  type        = string
}

variable "dynamodb_table" {
  description = "AWS DynamoDB table name to use for state locking"
  type        = string
}

variable "region" {
  description = "The AWS region that will contain the bucket for the remote state"
  type        = string
}
