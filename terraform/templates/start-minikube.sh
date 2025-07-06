#!/bin/bash

# Start Minikube cluster
echo "Starting Minikube cluster '${cluster_name}'..."

# Check if cluster already exists
if minikube status -p ${cluster_name} >/dev/null 2>&1; then
    echo "Cluster '${cluster_name}' already exists, starting it..."
    minikube start -p ${cluster_name}
else
    echo "Creating new Minikube cluster '${cluster_name}'..."
    minikube start \
        --driver=${driver} \
        --cpus=${cpus} \
        --memory=${memory} \
        -p ${cluster_name}
fi

# Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
minikube status -p ${cluster_name}

echo "Minikube cluster '${cluster_name}' is ready!" 