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

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform/state/main.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"  # Optional but recommended for state locking
  }
}

