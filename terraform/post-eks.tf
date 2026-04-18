resource "null_resource" "enable_vpc_cni_network_policy" {

  provisioner "local-exec" {
    command = <<EOT
aws eks update-kubeconfig --name ${aws_eks_cluster.eks.name} --region ${var.region}

kubectl patch configmap amazon-vpc-cni -n kube-system \
  --type merge \
  -p '{"data":{"enable-network-policy-controller":"true"}}'

kubectl set env daemonset/aws-node -n kube-system \
  NETWORK_POLICY_ENFORCING_MODE=standard

kubectl rollout restart daemonset/aws-node -n kube-system
kubectl rollout status daemonset/aws-node -n kube-system
EOT
  }

  depends_on = [
    aws_eks_addon.vpc_cni
  ]
}