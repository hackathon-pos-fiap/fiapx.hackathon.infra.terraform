output "deployment_name" {
  description = "Nome do deployment Kubernetes"
  value       = kubernetes_deployment.app.metadata[0].name
}