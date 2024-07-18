project_id      = ""
region          = "us-central1"
credentials     = "credentials.json"

# For VPC creation
name            = "dev-environment"
subnet_cidr     = ""


#For Compute instance creation
#service_account_id = 
#instance_name       = "dev-environment-mongodb"
machine_type        = "e2-small"
zone                = "us-central1-a"
image               = "ubuntu-2004-focal-v20220419"
type                = "pd-ssd"
size                = 10
network             = "dev-environment-vpc"

