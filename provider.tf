
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }

backend "s3" {
    bucket         = "s3back-end-project"      
    key            = "terraform.tfstate"
    region         = "eu-west-2"                   
    encrypt        = true
    dynamodb_table = "dynamo-db-back-end-setup01"
    use_lockfile = true
  }
}  
