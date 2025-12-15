variable region {
    default = "us-east-1"
}

variable "vpc" {
  type =string
  
}

variable "github_connection_arn" {
  description = "The Arn of the CodeStar for gitHub connection"
  type = string
 default     = "arn:aws:codeconnections:us-east-1:123456789012:connection/aEXAMPLE-8aad-4d5d-8878-dfcab0bc441f"
}

variable "github_repo_name" {
  description = "github reponame for version control"
  type = string
  default = "github-repositoryname/repo-name"
}