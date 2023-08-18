data "aws_iam_policy_document" "eks_nodes_assume_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_nodes_role" {
  name               = "${var.project}-${var.stage}-eks-nodes-role"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy_document" "eks_nodes_custom_policy" {
  dynamic "statement" {
    # for_each abaixo se comporta como se fosse no python um:
    # for parameter in options_and_parameters_settings.parameter_group_settings.parameters:
    for_each = var.eks_nodes_policy_statements
    
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "nodes_policies" {
  name   = "${var.project}-${var.stage}-custom-eks-nodes-policy"
  policy = data.aws_iam_policy_document.eks_nodes_custom_policy.json
}

resource "aws_iam_role_policy_attachment" "nodes_custom_policy_attachment" {
  role        = aws_iam_role.eks_nodes_role.name
  policy_arn  = aws_iam_policy.nodes_policies.arn
}
