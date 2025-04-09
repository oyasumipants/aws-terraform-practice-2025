# ECR Repository
resource "aws_ecr_repository" "main" {
  name = "${var.repository_name}-${var.environment}"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete         = true
  image_tag_mutability = "MUTABLE"

  tags = merge(
    {
      Name        = "${var.repository_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}
