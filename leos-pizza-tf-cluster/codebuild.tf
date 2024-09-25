resource "aws_codebuild_project" "pizza" {
  name          = var.codebuild_name
  description   = "My CodeBuild ${var.codebuild_name} project"
  build_timeout = 60
  service_role  = aws_iam_role.pizza.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${var.bucket_name_cache}/${var.codebuild_name}"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = var.ecr_url
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode             = true

    environment_variable {
      name  = "environment"
      value = var.environment
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.codebuild_name}-log-group"
      stream_name = "${var.codebuild_name}-log-stream"
    }
  }


  source {
    type            = "GITHUB"
    location        = var.repo_url
    git_clone_depth = 1
  }

  source_version = var.repo_branch
  

  vpc_config {
    vpc_id = aws_vpc.example.id

    subnets = private_subnets_cidr

    security_group_ids = [aws_security_group.eks_cluster]
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "pizza" {
  name               = "codebuild-${var.project_name}-${var.environment}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "pizza" {
  role   = aws_iam_role.pizza.name
  policy = data.aws_iam_policy_document.pizza.json
}