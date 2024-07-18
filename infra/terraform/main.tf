provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
  region = "us-west-2"
  acl    = "private"

  versioning {
    enabled = true
  }
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}



#Container Registry
resource "aws_ecr_repository" "flask_app_repo" {
  name = "my-flask-app"

  image_tag_mutability = "IMMUTABLE"

}

output "ecr_repository_url" {
  value = aws_ecr_repository.example.repository_url
}
