terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws"{
  region = "eu-west-2"
  access_key = "AKIA3XVK4RTIW5MPOPFU"
  secret_key= "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"
}
