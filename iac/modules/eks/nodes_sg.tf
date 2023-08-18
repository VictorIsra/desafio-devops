# EKS Cluster Security Group
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.project}-eks-nodes-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.network_settings.vpc

  tags = {
    Name = "${var.project}-eks-nodes-sg"
  }
}

resource "aws_security_group_rule" "nodes_internal" {
  # regra default, hardcoded e geral de inbound

  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_inbound" {
  # regra default, hardcoded e geral de inbound

  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_outbound" {
  # regra default, hardcoded e geral de outbound

  description = "Security group for all nodes in the cluster"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  type = "egress"
  security_group_id = aws_security_group.eks_nodes_sg.id # sg no qual quero associar a regra
}

resource "aws_security_group_rule" "nodes_ingress_rules" {
  count = length(var.eks_nodes_sg_statements.ingress_rules)

  type        = "ingress"
  description = var.eks_nodes_sg_statements.ingress_rules[count.index].description 
  from_port   = var.eks_nodes_sg_statements.ingress_rules[count.index].from_port
  to_port     = var.eks_nodes_sg_statements.ingress_rules[count.index].from_port
  protocol    = var.eks_nodes_sg_statements.ingress_rules[count.index].protocol
  
  # ATENCAO: cidr_blocks e security_groups sao mutua[count.index]lmente excludentes
  cidr_blocks               = var.eks_nodes_sg_statements.ingress_rules[count.index].cidr_blocks
  source_security_group_id  = var.eks_nodes_sg_statements.ingress_rules[count.index].source_security_group_id
  
  security_group_id = aws_security_group.eks_nodes_sg.id # sg no qual quero associar a regra
}

resource "aws_security_group_rule" "nodes_egress_rules" {
  count = length(var.eks_nodes_sg_statements.egress_rules)

  type        = "egress"
  description = var.eks_nodes_sg_statements.egress_rules[count.index].description
  from_port   = var.eks_nodes_sg_statements.egress_rules[count.index].from_port
  to_port     = var.eks_nodes_sg_statements.egress_rules[count.index].from_port
  protocol    = var.eks_nodes_sg_statements.egress_rules[count.index].protocol
  # ATENCAO: cidr_blocks e security_groups sao mutua[count.index]lmente excludentes
  cidr_blocks               = var.eks_nodes_sg_statements.egress_rules[count.index].cidr_blocks
  source_security_group_id  = var.eks_nodes_sg_statements.egress_rules[count.index].source_security_group_id
  security_group_id = aws_security_group.eks_nodes_sg.id # sg no qual quero associar a regra
}