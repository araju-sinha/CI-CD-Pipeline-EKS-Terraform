provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "eks-rds-github-state"
    key            = "ecr-rds/statefile/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock-table"
  }
}


resource "aws_ecr_repository" "flask_app_ecr-github" {
  name = "flask_app_ecr-github"

  tags = {
    Name = "flask_app_ecr-github"
  }
}

# VPC Configuration ------------- with 2 public subnets for app and 2 private subnets for RDS 
resource "aws_vpc" "my-vpc-01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc-01"
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "main-igw-01" {
  vpc_id = aws_vpc.my-vpc-01.id

  tags = {
    Name = "main-igw-01"
  }
}

# Private Subnets
resource "aws_subnet" "private_01" {
  vpc_id            = aws_vpc.my-vpc-01.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private_subnet_01"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks-cluster-01"      = "owned"
  }
}

resource "aws_subnet" "private_02" {
  vpc_id            = aws_vpc.my-vpc-01.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private_subnet_02"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks-cluster-01"      = "owned"
  }
}

# Public Subnets
resource "aws_subnet" "public_01" {
  vpc_id                  = aws_vpc.my-vpc-01.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_01"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-cluster-01"      = "owned"
  }
}

resource "aws_subnet" "public_02" {
  vpc_id                  = aws_vpc.my-vpc-01.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_02"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-cluster-01"      = "owned"
  }
}

#NAT gateway
resource "aws_eip" "nat-01" {
  domain = "vpc"

  tags = {
    Name = "nat-01"
  }
}

resource "aws_nat_gateway" "k8s-nat-01" {
  allocation_id = aws_eip.nat-01.id
  subnet_id     = aws_subnet.public_01.id

  tags = {
    Name = "k8s-nat-01"
  }

  depends_on = [aws_internet_gateway.main-igw-01]
}


# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw-01.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my-vpc-01.id

  route {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.k8s-nat-01.id
    }

  tags = {
    Name = "private-route"
  }
}


# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_01" {
  subnet_id      = aws_subnet.public_01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_02" {
  subnet_id      = aws_subnet.public_02.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_01" {
  subnet_id      = aws_subnet.private_01.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_02" {
  subnet_id      = aws_subnet.private_02.id
  route_table_id = aws_route_table.private.id
}


# Security Group ------------------------------------- EKS
resource "aws_security_group" "eks-sg-01" {
  vpc_id = aws_vpc.my-vpc-01.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg-01"
  }
}

# EKS Cluster terraform code  ------------------------
# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role-01" {
  name = "eks_cluster_role-01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# EKS Cluster Role Policy
resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy" {
  role       = aws_iam_role.eks_cluster_role-01.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create an IAM role for the EKS node group
resource "aws_iam_role" "eks_node_role" {
  name        = "eks-node-role"
  description = "EKS node role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

# Create an IAM policy attachment for the EKS node role
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "eks-cluster-01" {
  name     = "eks-cluster-01"
  role_arn = aws_iam_role.eks_cluster_role-01.arn

  vpc_config {
    subnet_ids         = [aws_subnet.public_01.id, aws_subnet.public_02.id, aws_subnet.private_01.id, aws_subnet.private_02.id]
# Enable private endpoint access
    endpoint_public_access = false
    endpoint_private_access = true  
}
  tags = {
    Name = "eks-cluster-01"
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_role_policy]
}

# Create an EKS node group
resource "aws_eks_node_group" "node-group-01" {
  cluster_name    = aws_eks_cluster.eks-cluster-01.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids      = [aws_subnet.public_01.id, aws_subnet.public_02.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3a.medium"]

  # Depends on the EKS cluster and IAM role
    depends_on = [
      aws_iam_role_policy_attachment.eks_node_policy,
      aws_iam_role_policy_attachment.eks_cni_policy,
      aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
}

