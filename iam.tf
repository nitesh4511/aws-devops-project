//code build assume policy

data "aws_iam_policy_document" "codebuild_policy_assume"{
   statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

   }
}

resource "aws_iam_role" "codebuild_role"{
    name = "${var.github_repo}-codebuild-role"
    assume_role_policy = data.aws_iam_policy_document.codebuild_policy_assume.json
}


resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = 2012-10-17
    Statement = [
      { Effect = "Allow", Action = ["ecr:GetAuthorizationToken"], Resource = "*"},
      { Effect = "Allow", Action = ["ecr:BatchCheckLayerAvailability","ecr:InitiateLayerUpload","ecr:UploadLayerPart","ecr:CompleteLayerUpload","ecr:PutImage","ecr:DescribeRepositories","ecr:GetDownloadUrlForLayer"], Resource = aws_ecr_repository.myapp-repository.arn },
      { Effect = "Allow", Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"], Resource = "*" },
      { Effect = "Allow", Action = ["s3:GetObject","s3:GetObjectVersion","s3:PutObject"], Resource = "*" },
      { Effect = "Allow", Action = ["ecs:RegisterTaskDefinition","ecs:DescribeTaskDefinition","ecs:DescribeServices"], Resource = "*" },
      { Effect = "Allow", Action = ["iam:PassRole"], Resource = "*" }
    ]
    
  }

  )
    
  
}


// ecs task assume policy 


data "aws_iam_policy_document" "ecstask_assume"{
   statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

   }
}

resource "aws_iam_role" "ecstask_role" {
  name               = "${var.github_repo}-ecstask_assume"
  assume_role_policy = data.aws_iam_policy_document.ecstask_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_managed" {
  role       = aws_iam_role.ecstask_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



// code deploy assume role 


data "aws_iam_policy_document" "codedeploy_assume"{
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_role"{
  name = "${var.github_repo}-codedeploy_role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume.json
}

resource "aws_iam_role_policy" "codedeploy_policy"{
  role = aws_iam_role.codedeploy_role.id
  name = "codedeploy-ecs-policy"
  policy = jsonencode({
    Version = 2012-10-17
    Statement = [
      { Effect = "Allow", Action = ["ecs:UpdateService","ecs:CreateTaskSet","ecs:DeleteTaskSet","ecs:DescribeServices","ecs:DescribeTaskSets","ecs:DescribeTasks","iam:PassRole"], Resource = "*" },
      { Effect = "Allow", Action = ["elasticloadbalancing:*","autoscaling:Describe*"], Resource = "*" },
      { Effect = "Allow", Action = ["cloudwatch:*","s3:Get*","s3:List*"], Resource = "*" }
    ]
  })
}


// code pipe line policy and assume role

data "aws_iam_policy_document" "codepipeline_assume"{
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role"{
  name = "${var.github_repo}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json
}

resource "aws_iam_role_policy" "codepipeline_policy"{
  role = aws_iam_role.codepipeline_role.id
  name = "codepipeline-policy"
  policy = jsonencode({
    Version = 2012-10-17
    Statement = [
      { Effect = "Allow", Action = ["s3:*"], Resource = "*" },
      { Effect = "Allow", Action = ["codebuild:StartBuild","codebuild:BatchGetBuilds"], Resource = "*" },
      { Effect = "Allow", Action = ["codedeploy:CreateDeployment","codedeploy:GetDeployment","codedeploy:GetDeploymentConfig"], Resource = "*" },
      { Effect = "Allow", Action = ["iam:PassRole"], Resource = "*" }
    ]
  })
}
