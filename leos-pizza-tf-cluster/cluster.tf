resource "aws_eks_cluster" "eksKubernetesTest" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eksKubernetesTest.arn
  version  = var.cluster_version


  kubernetes_network_config {
    service_ipv4_cidr = "172.16.0.0/16"
  }

  vpc_config {
    subnet_ids              = var.private_subnets_cidr
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = false

  }
  depends_on = [
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSVPCResourceController,
  ]
}