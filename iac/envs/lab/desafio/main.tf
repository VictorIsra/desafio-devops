module "vpc" {
  source  = "../../../modules/vpc"

  stage   = local.variables_shared.stage
  project = local.variables_shared.project

  vpc_settings = local.variables_vpc.vpc_settings
  gateways_settings = local.variables_vpc.gateways_settings
  subnet_settings = local.variables_vpc.subnet_settings
}

module "image_repository" {
  
  source = "../../../modules/ecr"

  stage   = local.variables_shared.stage
  project = local.variables_shared.project

  image_tag_mutability = local.variables_ecr.image_tag_mutability
}

module "eks_cluster" {
  source = "../../../modules/eks"

  stage = local.variables_shared.stage
  project = local.variables_shared.project

  nodes_settings = local.variables_eks.nodes_settings
  cluster_settings = local.variables_eks.cluster_settings
  network_settings = local.variables_eks.network_settings 
  eks_cluster_policy_statements = local.variables_eks.eks_cluster_policy_statements
  eks_nodes_policy_statements = local.variables_eks.eks_nodes_policy_statements
  eks_cluster_sg_statements = local.variables_eks.eks_cluster_sg_statements
  eks_nodes_sg_statements = local.variables_eks.eks_nodes_sg_statements
}