

variable "credentials" {
    description = "The credentials of the project"
}


variable "project_id" {
    description = "The unique project ID"
}

variable "region" {
    description = "It has the region of the project"
}

# For VPC creation
variable "name" {
    description = "The name of the VPC network"
}

variable "subnet_cidr" {
    description = "It will contain the subnet_cidr range"
}

#For Compute instance creation




#For compute_instance

/*
variable "service_account_id"{
    description = "The service_account used by Compute instance"
}
*/


variable "machine_type" {
    description = "The machine_type of the compute instance"
}

variable "zone" {
    description = "The zone in which the compute instance will be created"
}

variable "image" {
    description = "The image of the boot disk"
}

variable "type" {
    description = "The type of the boot disk"
}

variable "size" {
    type = number
    description = "The size of the boot disk"
}


variable "network"{
    description = "The network inside the compute instance will be created"
}








