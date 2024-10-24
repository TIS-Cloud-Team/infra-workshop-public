## Create IAM user and policy for S3 bucket - my app user - PutObject permission only
resource "aws_iam_user" "user" {
  name = "s3-iam-user-${local.app_name}"
  ##path = "/system/"
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user" {
  name = "s3-iam-user-policy-${local.app_name}"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/*"
    }
  ]
}
EOF
}

output "s3_iam_access_key" {
  value = aws_iam_access_key.user.id
}

output "s3_iam_secret_key" {
  value = aws_iam_access_key.user.secret
  sensitive = true
}

## after terraform apply
## terraform output --json
## terraform output s3_iam_access_key
## terraform output s3_iam_secret_key