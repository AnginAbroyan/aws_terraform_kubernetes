//// IAM ROLES
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_ec2_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "rds_full_access" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}


//// EKS


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_id


  enable_irsa = true

  eks_managed_node_group_defaults = {
    instance_types = [var.instance_type]
    disk_size      = var.node_disk_size //20
  }

  eks_managed_node_groups = {
    angin_app = {
      desired_capacity = var.node_desired_capacity
      max_capacity     = var.node_max_capacity
      min_capacity     = var.node_min_capacity

      instance_type = var.instance_type
      capacity_type = var.node_capacity_type //"SPOT"
    }
  }
  iam_role_arn = aws_iam_role.eks_node_role.arn
  tags         = merge(var.tags, { Name = "${var.project_name}-EKS" })
}

resource "kubernetes_namespace" "deployment" {
  metadata {
    name = var.kube_namespace //"deployment"
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [module.eks]
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
  }
}

resource "helm_release" "angin_app" {
  name       = "angin-app"
  namespace  = var.kube_namespace
#  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "../../charts/webapp"
  version    = "0.1.0"
  depends_on = [module.eks, null_resource.update_kubeconfig]

  values = [
    file("${path.module}/../../../charts/webapp/values.yaml"),
#    file("${path.module}/../../../secrets.yaml")
  ]
}


// NGINX Ingress Controller using Helm
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = var.kube_namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.18"
  depends_on = [module.eks, null_resource.update_kubeconfig]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}





