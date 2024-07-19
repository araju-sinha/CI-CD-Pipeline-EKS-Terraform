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

  tags = {
    Name = "flask_app_ecr"
  }
}


