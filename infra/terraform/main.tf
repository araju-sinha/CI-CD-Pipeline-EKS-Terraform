provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "eks-rds-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
  access_key = ${{ secrets.AWS_ACCESS_KEY }}
  secret_key = ${{ secrets.AWS_SECRET_ACCESS_KEY }}
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
