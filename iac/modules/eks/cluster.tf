resource "aws_eks_cluster" "this" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.27"

  enabled_cluster_log_types = var.cluster_settings.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.network_settings.cluster_subnets
    endpoint_private_access = true
    endpoint_public_access  = true # por como false em casos de ambientes produtivos e usar bastion/vpn para comunicação segura com o cluster
    public_access_cidrs     = ["0.0.0.0/0"] # em ambientes produtivos, restringir acesso apenas a ips ou security-groups conhecidos!!
  }

  depends_on = [
    aws_iam_role_policy_attachment.default_eks_cluster_policy_attachment
  ]
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
