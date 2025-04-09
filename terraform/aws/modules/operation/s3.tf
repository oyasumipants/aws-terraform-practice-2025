resource "aws_s3_bucket" "scripts_bucket" {
  bucket = "${var.prefix}-operation-scripts"

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-operation-scripts"
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "scripts_bucket" {
  bucket = aws_s3_bucket.scripts_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "scripts_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.scripts_bucket]
  bucket     = aws_s3_bucket.scripts_bucket.id
  acl        = "private"
}

resource "aws_s3_bucket_versioning" "scripts_bucket" {
  bucket = aws_s3_bucket.scripts_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "scripts_bucket" {
  bucket = aws_s3_bucket.scripts_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "scripts_bucket" {
  bucket                  = aws_s3_bucket.scripts_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "scripts_bucket_access" {
  name        = "${var.prefix}-scripts-bucket-access"
  description = "Policy to allow access to the scripts S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.scripts_bucket.arn,
          "${aws_s3_bucket.scripts_bucket.arn}/*"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "scripts_bucket_access" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.scripts_bucket_access.arn
}
