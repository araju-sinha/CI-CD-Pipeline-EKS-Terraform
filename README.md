# devops-assigment

## Setup and execute an application provided in app

This is a simple Flask application with a couple of routes.

1. Create a virtual environment:
   ```bash
   python -m venv venv
   ```
2. source venv/bin/activate
3. pip install -r requirements.txt
4. python main.py
5. curl http://127.0.0.1:5000/hello/John - To test the endpoint

## Assignment Steps

1. Infrastructure provisioning (Terraform / AWS CDK)

   * Update the provided "main.tf" under infra/terraform (if using terraform)
   * Update the provided "main.py" under infra/cdk (if using AWS CDK)
   * Write the terraform script to configure the following:

     * IAM Role with necessary permissions
     * Container Registry
     * VPC on which EKS and RDS will be deployed
     * Amazon EKS cluster
     * Amazon RDS (PostgresSQL) instance
     * IAM Policies and Trust relationship so that EKS cluster can access the RDS2
   * Update the respective Makefile target in the "Makefile" located at top level
2. Application Deployment

   * Update the Dockerfile under app directory
   * Update the respective Makefile target in the "Makefile" located at top level
3. CI/CD Pipeline with Github Actions

   * Update the "ci-cd-pipeline.yml" located at .github/workflows/
   * Workflows should:
     * Trigger on pushes and pull request on the main branch
     * Build and push the docker image of application
     * Deploy the application to the EKS cluster

## Evaluation Criteria

1. Correctness and completion of the Terraform or AWS CDK infrastructure code
2. Proper setup and functionality of Github Actions CI/CD pipeline
3. Code quality and adherence of best practices
4. Implement rollback mechanisms (Bonus)
5. Implement monitoring and alert mechanism (Bonus)
