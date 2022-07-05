resource "aws_iam_role" "eks_cluster_role" {
    name = join("-", ["aline", "kwi", var.env, "eks", "role"])
    assume_role_policy = data.aws_iam_policy_document.cluster_policy_document.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks" {
    name = join("-", ["aline", "kwi", var.env, "eks"])
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = [for subnet in var.private : subnet.id]
        endpoint_private_access = true
        endpoint_public_access = true
    }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy, aws_iam_role_policy_attachment.eks_vpc_policy]

    tags = {
        Name = join("-", ["aline", "kwi", var.env, "eks"])
    }
}