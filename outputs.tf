output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "load_balancer_ip" {
  value = kubernetes_service.nodejs_service.status[0].load_balancer.ingress[0].ip
}
