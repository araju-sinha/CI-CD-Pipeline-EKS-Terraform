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
    bucket         = "eks-rds-state-bucket"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"  # Optional but recommended for state locking
  }
}


#Container Registry
resource "aws_ecr_repository" "flask_app_ecr" {
  name = "flask_app_ecr"

  tags = {
    Name = "flask_app_ecr"
  }
}


