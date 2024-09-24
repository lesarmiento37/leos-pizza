data "tls_certificate" "eksKubernetesTest" {
  url = aws_eks_cluster.eksKubernetesTest.identity[0].oidc[0].issuer
}
data "aws_iam_policy_document" "eksKubernetesTest_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksKubernetesTest.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksKubernetesTest.arn]
      type        = "Federated"
    }
  }
}