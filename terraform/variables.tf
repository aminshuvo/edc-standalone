// Variables for Kubernetes cluster provisioning

variable "cluster_name" {
  description = "Name of the Minikube cluster"
  type        = string
  default     = "edc-standalone"
}

variable "driver" {
  description = "Minikube driver to use"
  type        = string
  default     = "docker"
}

variable "cpus" {
  description = "Number of CPUs to allocate to Minikube"
  type        = number
  default     = 4
}

variable "memory" {
  description = "Amount of memory to allocate to Minikube (in MB)"
  type        = number
  default     = 8192
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
} 