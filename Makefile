deploy-infra:
# Add a command line to deploy the infrastructure on AWS using terrform or AWS CDK
deploy-infra:
	@echo "Deploying infrastructure using Terraform..."
	cd infra/terraform && terraform init && terraform apply -auto-approve


build-image:
# Add a command line to build the docker image
build-image:
	@echo "Building Docker image..."
	docker build -t app-image .


push-image:
# Add a command line to push the docker image to the registry
push-image:
	@echo "Pushing Docker image to ECR..."
	aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<region>.amazonaws.com
	docker tag app-image:latest <your-account-id>.dkr.ecr.<region>.amazonaws.com/app-repo:latest
	docker push <your-account-id>.dkr.ecr.<region>.amazonaws.com/app-repo:latest


deploy-container:
# Add a command line to deploy the container on the AWS EKS setup as part of infrastructure deployment
deploy-container:
	@echo "Deploying container to EKS..."
	kubectl config set-cluster my-cluster --server=https://<eks-cluster-endpoint> --certificate-authority=<path-to-certificate>
	kubectl config set-credentials aws --token=<your-token>
	kubectl config set-context my-cluster --cluster=my-cluster --user=aws
	kubectl config use-context my-cluster
	kubectl apply -f k8s/deployment.yaml



terraform-apply:
   terraform init
   terraform apply -auto-approve

docker-build:
   docker build -t app-image .

docker-push:
   docker tag app-image:latest <your-account-id>.dkr.ecr.<region>.amazonaws.com/app-repo:latest
   $(aws ecr get-login --no-include-email --region <region>)
   docker push <your-account-id>.dkr.ecr.<region>.amazonaws.com/app-repo:latest

