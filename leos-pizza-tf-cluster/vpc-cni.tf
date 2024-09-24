resource "aws_eks_addon" "eksKubernetesTest" {
  cluster_name = aws_eks_cluster.eksKubernetesTest.name
  addon_name   = "vpc-cni"
}

resource "aws_iam_openid_connect_provider" "eksKubernetesTest" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eksKubernetesTest.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eksKubernetesTest.identity[0].oidc[0].issuer
}