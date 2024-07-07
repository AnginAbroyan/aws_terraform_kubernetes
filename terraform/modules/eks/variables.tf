variable cluster_name {
  description = "Name of the EKS cluster"
  type        = string
}

variable vpc_id {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable private_subnet_id {
  type = list(string)
}
variable region {
}
variable instance_type {}

variable project_name {
}

variable tags {
}


variable node_disk_size {}

variable node_desired_capacity {}

variable node_max_capacity {}

variable node_min_capacity {}

variable node_capacity_type {}
variable kube_namespace {}
variable docker_image {}
variable port {}