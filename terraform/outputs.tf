// Outputs for Kubernetes cluster

output "cluster_name" {
  description = "Name of the Minikube cluster"
  value       = var.cluster_name
}

output "cluster_status" {
  description = "Status message for the cluster"
  value       = "Minikube cluster '${var.cluster_name}' is ready for EDC deployment"
}

output "kubectl_config" {
  description = "Command to configure kubectl context"
  value       = "kubectl config use-context ${var.cluster_name}"
}

output "minikube_dashboard" {
  description = "Command to open Minikube dashboard"
  value       = "minikube dashboard -p ${var.cluster_name}"
}

output "minikube_tunnel" {
  description = "Command to create tunnel for external access"
  value       = "minikube tunnel -p ${var.cluster_name}"
} 