output "eks" {
    description = "EKS Cluster for the project."
    value = aws_eks_cluster.eks
}

output "eks_role" {
    description = "The Cluster role for the ECS cluster."
    value = aws_iam_role.eks_cluster_role
}