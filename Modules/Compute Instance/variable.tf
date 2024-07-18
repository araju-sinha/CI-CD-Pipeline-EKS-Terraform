/*
variable "service_account_id"{
    description = "The service_account used by Compute instance"
}
*/
variable "name" {
    description = "The name of the instnace"
}

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

