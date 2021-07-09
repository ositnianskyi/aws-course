resource "aws_iam_instance_profile" "PublicInstanceProfile" {
  name = "PublicInstanceProfile"
  role = aws_iam_role.PublicEC2Role.name
}

resource "aws_iam_role" "PublicEC2Role" {
  name = "PublicEC2Role"
  assume_role_policy = data.aws_iam_policy_document.ec2-role-policy-document.json
}

resource "aws_iam_instance_profile" "PrivateInstanceProfile" {
  name = "PrivateInstanceProfile"
  role = aws_iam_role.PublicEC2Role.name
}

resource "aws_iam_role" "PrivateEC2Role" {
  name = "PrivateEC2Role"
  assume_role_policy = data.aws_iam_policy_document.ec2-role-policy-document.json
}

resource "aws_iam_role_policy" "public_role_policy" {
  name = "public_role_policy"
  role = aws_iam_role.PublicEC2Role.id
  policy = data.aws_iam_policy_document.public-policy-document.json
}

resource "aws_iam_role_policy" "private_role_policy" {
  name = "private_role_policy"
  role = aws_iam_role.PrivateEC2Role.id
  policy = data.aws_iam_policy_document.private-policy-document.json
}

data "aws_iam_policy_document" "ec2-role-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "public-policy-document" {
  statement {
    actions = ["s3:*"]
    resources = ["*"]
  }

  statement {
    actions = ["dynamodb:*"]
    resources = ["*"]
  }

  statement {
    actions = ["sns:*"]
    resources = ["*"]
  }

  statement {
    actions = ["sqs:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "private-policy-document" {
  statement {
    actions = ["s3:*"]
    resources = ["*"]
  }

  statement {
    actions = ["sns:*"]
    resources = ["*"]
  }

  statement {
    actions = ["sqs:*"]
    resources = ["*"]
  }
}