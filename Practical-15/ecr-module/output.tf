output "ecr_repo_url" {
  description = "URL for the ECR repository"
  value       = aws_ecr_repository.ecr_repo.repository_url
}
