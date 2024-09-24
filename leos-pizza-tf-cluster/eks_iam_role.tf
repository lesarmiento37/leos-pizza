resource "aws_iam_role" "eksKubernetesTest" {
  name = "eks-cluster-pizza-${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role" "eksKubernetesTest2" {
  assume_role_policy = data.aws_iam_policy_document.eksKubernetesTest_assume_role_policy.json
  name               = "eksKubernetesTest-vpc-cni-${var.environment}-role"
}