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


variable "region" {
  #  default = "eu-central-1"  # Frankfurt
  default = "eu-west-3"  # Paris
}