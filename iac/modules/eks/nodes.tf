# EKS Node Groups
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.project
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.network_settings.nodegroup_subnets

  dynamic scaling_config {
    for_each = var.nodes_settings.scaling_config

    content {
      desired_size = scaling_config.value.desired_size
      max_size     = scaling_config.value.max_size
      min_size     = scaling_config.value.min_size
    }
  }

  ami_type       = var.nodes_settings.ami_type
  capacity_type  = var.nodes_settings.capacity_type
  disk_size      = var.nodes_settings.disk_size
  instance_types = var.nodes_settings.instance_types

  # tags = merge(
  #   var.tags
  # )

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}