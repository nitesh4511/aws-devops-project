terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws"{
  region = "eu-west2"
  ACCESS_KEY = ""
  SECRET_KEY= ""
}
