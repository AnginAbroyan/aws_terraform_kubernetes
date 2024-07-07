variable "region" {
  #  default = "eu-central-1"  # Frankfurt
  default = "eu-west-3"  # Paris
}

#VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = [
    "10.0.0.0/24",
    "10.0.36.0/24",
  ]
}

variable "private_subnet_cidr" {
  default = [
    "10.0.64.0/24",
    "10.0.128.0/24"
  ]
}

#Project
variable "project_name" {
  default = "angin-app"
}


variable "tags" {
  default = {
    Project     = "Terraform-angin"
    Environment = "dev"
    Terraform   = "true"
  }
}


variable "instance_type" {
  default = "t3.small"
}


#ECR

variable "ecr_repos" {
  description = "List of repo names"
  default     = ["ecr-angin"]
}


///RDS
variable db_identifier {
  default = "mysql-db"
}

variable "db_engine" {
  default = "mysql"
}
variable engine_version {
  default = "8.0.35"
}
variable "instance_class" {
  default = "db.t3.micro"
}
variable "allocated_storage" {
  default = 5
}
variable "storage_type" {
  default = "gp2"
}
variable "db_name" {
  default = "bluebirdhotel"
}
variable "db_username" {
  default = "changeme"

}
variable "db_password" {
  default = "changeme"
}

//eks
variable "cluster_name" {
  default = "cluster-angin"
}


variable "node_disk_size" {
  default = 20
}

variable "node_desired_capacity" { default = 1 }

variable "node_max_capacity" { default = 1 }

variable "node_min_capacity" { default = 1 }

variable "node_capacity_type" {
  default = "SPOT"
}
variable "kube_namespace" { default = "deployment" }
variable "docker_image" {
  default = "changeme"
}
variable "port" {
  default = 80
}


