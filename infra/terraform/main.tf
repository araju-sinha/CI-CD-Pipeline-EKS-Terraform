terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#Container Registry
resource "aws_ecr_repository" "flask_app_ecr" {
  name = "flask_app_ecr"

  image_tag_mutability = "IMMUTABLE"
  tags = {
    Name = "flask_app_ecr"
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.example.repository_url
}
