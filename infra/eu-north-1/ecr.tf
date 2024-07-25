
module "private_ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "v2.2.1"
  for_each = toset(var.services)
  repository_name = each.value
  repository_type = "private"
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_image_scan_on_push = false
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
      rules = [
        {
          rulePriority = 1,
          description  = "Keep last 30 images",
          selection = {
            tagStatus     = "tagged",
            tagPrefixList = ["v"],
            countType     = "imageCountMoreThan",
            countNumber   = 30
          },
          action = {
            type = "expire"
          }
        }
      ]
    })

  tags = local.tags
}