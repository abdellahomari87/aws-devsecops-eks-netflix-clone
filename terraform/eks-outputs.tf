output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_node_group_name" {
  value = aws_eks_node_group.eks_nodes.node_group_name
}

output "vpc_cni_irsa_role_arn" {
  value = aws_iam_role.vpc_cni_irsa_role.arn
}