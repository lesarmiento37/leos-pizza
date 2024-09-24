variable "environment" {
  description = "Deployment Environment"
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
}

variable "availability_zones" {
  type        = list(any)
  description = "AZ in which all the resources will be deployed"
}

variable "ecr_name" {
  type        = string
  description = "The name of the ecr"
}
variable "eks_node_name" {
  type        = string
  description = "The name of the nodegroup"
}
variable "node_disk" {
  type        = string
  description = "The size of nodegroup disk"
}
variable "node_instance_type" {
  type        = list(any)
  description = "The size of the nodegroups"
}
variable "cluster_name" {
  type        = string
  description = "The name of the eks cluster"
}
variable "cluster_version" {
  type        = string
  description = "The version of the eks cluster"
}
variable "vpc_id"{
  description = "VPC ID"
}

variable "region" {
  description = "AWS Region"
}