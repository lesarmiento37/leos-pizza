output "endpoint" {
  value = aws_eks_cluster.eksKubernetesTest.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eksKubernetesTest.certificate_authority[0].data
}