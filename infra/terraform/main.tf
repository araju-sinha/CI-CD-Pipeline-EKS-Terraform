provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = var.region
  }
}


variable "region" {
  default = "us-west-1"
}


#Container Registry
resource "aws_ecr_repository" "flask_app_repo" {
  name = "my-flask-app"

  image_tag_mutability = "IMMUTABLE"

}

output "ecr_repository_url" {
  value = aws_ecr_repository.example.repository_url
}
