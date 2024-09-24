resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eksKubernetesTest.name
  node_group_name = var.eks_node_name
  node_role_arn   = aws_iam_role.eksKubernetesTest.arn
  subnet_ids      = var.private_subnets_cidr
  disk_size       = var.node_disk
  instance_types  = var.node_instance_type
  #remote_access {
  #  ec2_ssh_key = var.ssh_key_name
  #}
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  labels = {
    ambiente = var.environment
  }
  depends_on = [
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEC2ContainerRegistryReadOnly,
  ]
}
