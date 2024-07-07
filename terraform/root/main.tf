module "vpc" {
  source              = "../modules/vpc"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  project_name        = var.project_name
  tags                = var.tags
}


module "security_groups" {
  source       = "../modules/security_group"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  tags         = var.tags
}

module "rds" {

  source            = "../modules/rds"
  allocated_storage = var.allocated_storage
  db_engine         = var.db_engine
  db_identifier     = var.db_identifier
  db_name           = var.db_name
  db_password       = var.db_password
  db_sg_id          = module.security_groups.db_sg_id
  db_username       = var.db_username
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  private_subnet    = module.vpc.private_subnet
  project_name      = var.project_name
  storage_type      = var.storage_type
  tags              = var.tags
}

module "eks" {
  source                = "../modules/eks"
  cluster_name          = var.cluster_name
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = module.vpc.private_subnet
  instance_type         = var.instance_type
  docker_image          = var.docker_image
  kube_namespace        = var.kube_namespace
  node_capacity_type    = var.node_capacity_type
  node_desired_capacity = var.node_desired_capacity
  node_disk_size        = var.node_disk_size
  node_max_capacity     = var.node_max_capacity
  node_min_capacity     = var.node_min_capacity
  port                  = var.port
  project_name          = var.project_name
  tags                  = var.tags
}

module "ecr" {
  source    = "../modules/ecr"
  ecr_repos = var.ecr_repos
}