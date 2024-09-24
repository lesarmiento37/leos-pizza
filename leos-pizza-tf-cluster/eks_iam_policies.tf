resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-ElasticLoadBalancingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.eksKubernetesTest.name
}
resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.eksKubernetesTest.name
}