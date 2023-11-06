###################
# Main EC2 IAM role
data "aws_iam_policy_document" "main" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main_ec2" {
  name               = "main_ec2_role"
  assume_role_policy = data.aws_iam_policy_document.main.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "main_ec2" {
  role       = aws_iam_role.main_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "main_ec2" {
  name = "Main-ec2-instance-profile"
  role = aws_iam_role.main_ec2.name
}

#############################
# CodeDeploy service IAM role
data "aws_iam_policy_document" "codedeploy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy" {
  name               = "codeDeployForDjango"
  assume_role_policy = data.aws_iam_policy_document.codedeploy.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# resource "aws_iam_role_policy_attachment" "ecs_agent" {
#   role       = aws_iam_role.ecs_agent.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }


###########################
# S3 static assets IAM role
data "aws_iam_policy_document" "static_assets" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.static.arn}",
      "${aws_s3_bucket.static.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "manage_s3_static_assets" {
  name        = "Manage-Static-Assets"
  description = "Policy used by EC2 instance to manage S3 objects"
  policy      = data.aws_iam_policy_document.static_assets.json
}

resource "aws_iam_role_policy_attachment" "static_assets" {
  role       = aws_iam_role.main_ec2.name
  policy_arn = aws_iam_policy.manage_s3_static_assets.arn
}

################
# ECR Access IAM
data "aws_iam_policy_document" "ecr_access" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRegistry",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.main_ec2.name
  policy_arn = aws_iam_policy.ecr_access.arn
}

resource "aws_iam_policy" "ecr_access" {
  name        = "ECR-Access"
  description = "Policy used by EC2 instance to login and pull images from ECR"
  policy      = data.aws_iam_policy_document.ecr_access.json
}

################
# CodeDeploy EC2 IAM
resource "aws_iam_role_policy_attachment" "codedeploy_ec2" {
  role       = aws_iam_role.main_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_role_policy_attachment" "codedeploy_asg" {
  role       = aws_iam_role.main_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
}

#####################
# CloudWatch Logs IAM