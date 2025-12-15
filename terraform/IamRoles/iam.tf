resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_service_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
    }],
  })
}


data "aws_iam_policy_document" "codebuild_assume" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
  
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_service_role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json
}



resource "aws_iam_policy_attachment" "codebuid_attach_policy" {
  name       = "codebuild-service-role-policy-attachment" 
  roles = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  
}



