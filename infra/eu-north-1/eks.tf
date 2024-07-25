
module "eks_vi_test" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name}-test1"
  cluster_version = "1.30"

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  # EKS Addons
  cluster_addons = {
    # coredns is required in order to access mongodb using dns names
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}

  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    tags = {
      "k8s.io/cluster-autoscaler/enabled" = true
      "k8s.io/cluster-autoscaler/${module.eks_vi_test.cluster_name}" = true
    }
  }
  eks_managed_node_groups = {
    vi-app1 = {
      ami_type        = "AL2023_x86_64_STANDARD"
      instance_types = 	["t3.medium","t3.small"]
      min_size = 2
      max_size = 5
      # This value is ignored after the initial creation
      desired_size = 2
      capacity_type = "SPOT"
      enable_monitoring = false
      enable_metrics = false
    }
  }

  tags = local.tags
}
