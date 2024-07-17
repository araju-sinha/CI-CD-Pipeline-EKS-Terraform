provider "aws" {
  region = "us-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


#Container Registry
resource "aws_ecr_repository" "flask_app_repo" {
  name = "my-flask-app"

  image_tag_mutability = "IMMUTABLE"

}
