ci-cd-pipeline pipeline...
 Pipeline with build the docker image and push to AWS conatiner registry (ECR) and use that image to deply on EKS cluster
 we need ECR already created and EKS Cluster and VPC. 
 we are fetching the ecr created url and using to build and push image to ecr.


ci-cd-terraform pipeline...
Fully automated pipeline with secrets in github secrets used to authenticate
statefile stored in AWS S3 
we are creating and infrastructure via same pipeline like first pipeline will authenticate and build the infrastructure via terraform (main.tf) - ecr, vpc, cluster, iam roles and policies
within same pipeline it will use the ecr created on which image will be pushed with comitt id used as tag

