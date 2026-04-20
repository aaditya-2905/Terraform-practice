module "ecr" {
  source          = "terraform-aws-modules/ecr/aws"
  repository_name = "my-three-tier-aws-tf-project-${var.aws_region}"
  repository_read_write_access_arns = [
    var.ecs_task_execution_role_arn
  ]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan",
          countNumber = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}
