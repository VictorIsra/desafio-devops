data "aws_iam_policy_document" "eks_cluster_assume_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project}-${var.stage}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
}

resource "aws_iam_role_policy_attachment" "default_eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "eks_cluster_custom_policy" {
  dynamic "statement" {
    # for_each abaixo se comporta como se fosse no python um:
    # for parameter in options_and_parameters_settings.parameter_group_settings.parameters:
    for_each = var.eks_cluster_policy_statements
    
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
      
      dynamic "condition" {
        for_each = coalesce(statement.value.condition, [])

        content {
          test = condition.value.test
          variable = condition.value.variable
          values = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "cluster_policies" {
  name   = "${var.project}-${var.stage}-custom-eks-cluster-policy"
  policy = data.aws_iam_policy_document.eks_cluster_custom_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_custom_policy_attachment" {
  role        = aws_iam_role.eks_cluster_role.name
  policy_arn  = aws_iam_policy.cluster_policies.arn
}