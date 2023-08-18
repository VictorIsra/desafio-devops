# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project}-eks-cluster-sg"
  description = "Cluster communication with worker nodes" # dps padronizar comentarios ou td pt ou td ingles
  vpc_id      = var.network_settings.vpc

  tags = {
    Name = "${var.project}-eks-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  # regra default, hardcoded e geral de inbound
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_rules" {
  count = length(var.eks_cluster_sg_statements.ingress_rules)

  type        = "ingress"
  description = var.eks_cluster_sg_statements.ingress_rules[count.index].description 
  from_port   = var.eks_cluster_sg_statements.ingress_rules[count.index].from_port
  to_port     = var.eks_cluster_sg_statements.ingress_rules[count.index].from_port
  protocol    = var.eks_cluster_sg_statements.ingress_rules[count.index].protocol
  
  # ATENCAO: cidr_blocks e security_groups sao mutualmente excludentes
  cidr_blocks               = var.eks_cluster_sg_statements.ingress_rules[count.index].cidr_blocks
  source_security_group_id  = var.eks_cluster_sg_statements.ingress_rules[count.index].source_security_group_id
  
  security_group_id = aws_security_group.eks_cluster_sg.id # sg no qual quero associar a regra
}

resource "aws_security_group_rule" "cluster_egress_rules" {
  count = length(var.eks_cluster_sg_statements.egress_rules)

  type        = "egress"
  description = var.eks_cluster_sg_statements.egress_rules[count.index].description
  from_port   = var.eks_cluster_sg_statements.egress_rules[count.index].from_port
  to_port     = var.eks_cluster_sg_statements.egress_rules[count.index].from_port
  protocol    = var.eks_cluster_sg_statements.egress_rules[count.index].protocol
  # ATENCAO: cidr_blocks e security_groups sao mutua[count.index]lmente excludentes
  cidr_blocks               = var.eks_cluster_sg_statements.egress_rules[count.index].cidr_blocks
  source_security_group_id  = var.eks_cluster_sg_statements.egress_rules[count.index].source_security_group_id
  security_group_id = aws_security_group.eks_cluster_sg.id # sg no qual quero associar a regra
}

resource "aws_security_group_rule" "cluster_outbound" {
  # regra default, hardcoded e geral de outbound
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 65535
  type                     = "egress"
}