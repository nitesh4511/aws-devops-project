resource "aws_s3_bucket" "terraform_S3_backend" {
  bucket = "terraform_S3_backend"

  tags = {
    Name = "terraform_S3_backend"
  }
}

resource "aws_dynamodb_table" "terraform_dynamoDB_backend" {
  hash_key = "lokckId"
  name           = "terraform_dynamoDB_backend"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "UserId"
    type = "S"
  }
}