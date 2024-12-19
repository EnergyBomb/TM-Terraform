#S3
data "aws_iam_policy_document" "s3_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::tm-lode-bucket","arn:aws:s3:::tm-lode-bucket/*"]
  }
}

#EC2 role
data "aws_iam_policy_document" "AssumeEC2fullAccessToS3" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "EC2FullAccessToS3Role" {
  assume_role_policy = data.aws_iam_policy_document.AssumeEC2fullAccessToS3.json
  name = "EC2FullAccessToS3Role"
}

resource "aws_iam_role_policy" "EC2_s3_policy" {
  role = aws_iam_role.EC2FullAccessToS3Role.id
  policy = data.aws_iam_policy_document.s3_permissions.json
}

resource "aws_iam_instance_profile" "EC2FullAccessToS3Profile" {
  name = "EC2FullAccessToS3Profile"
  role = aws_iam_role.EC2FullAccessToS3Role.name
}

#Lambda
data "aws_iam_policy_document" "assumerole" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "LambdaIAM"
  assume_role_policy = data.aws_iam_policy_document.assumerole.json
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "LambdaS3Policy"
  role = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.s3_permissions.json
}