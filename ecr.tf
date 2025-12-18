resource "aws_ecr_repository" "myapp-repository" {
  name = "${var.github_repo}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}