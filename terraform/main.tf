# Terraform configuration for EDC Standalone Kubernetes deployment
# This configuration provisions a Minikube cluster with EDC components

terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Local provider for executing commands
provider "local" {}

# Data source to get current user
data "external" "current_user" {
  program = ["sh", "-c", "echo '{\"user\": \"'$(whoami)'\"}'"]
}

# Create Minikube cluster
resource "local_file" "minikube_start_script" {
  content = templatefile("${path.module}/templates/start-minikube.sh", {
    cluster_name = var.cluster_name
    driver       = var.driver
    cpus         = var.cpus
    memory       = var.memory
  })
  filename = "${path.module}/scripts/start-minikube.sh"
  file_permission = "0755"
}

resource "null_resource" "start_minikube" {
  triggers = {
    cluster_name = var.cluster_name
    driver       = var.driver
    cpus         = var.cpus
    memory       = var.memory
  }

  provisioner "local-exec" {
    command = local_file.minikube_start_script.filename
  }

  provisioner "local-exec" {
    when    = destroy
    command = "minikube delete -p ${self.triggers.cluster_name}"
  }
}

# Enable Minikube addons
resource "null_resource" "enable_addons" {
  depends_on = [null_resource.start_minikube]

  provisioner "local-exec" {
    command = "minikube addons enable ingress -p ${var.cluster_name}"
  }

  provisioner "local-exec" {
    command = "minikube addons enable metrics-server -p ${var.cluster_name}"
  }
}

# Wait for cluster to be ready and configure kubectl
resource "null_resource" "configure_kubectl" {
  depends_on = [null_resource.enable_addons]

  provisioner "local-exec" {
    command = "kubectl config use-context ${var.cluster_name}"
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create namespaces
resource "kubernetes_namespace" "edc_standalone" {
  metadata {
    name = "edc-standalone"
    labels = {
      app = "edc-standalone"
    }
  }
  
  depends_on = [null_resource.configure_kubectl]
}

resource "kubernetes_namespace" "edc_peer" {
  metadata {
    name = "edc-peer"
    labels = {
      app = "edc-peer"
    }
  }
  
  depends_on = [null_resource.configure_kubectl]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      app = "monitoring"
    }
  }
  
  depends_on = [null_resource.configure_kubectl]
}

 