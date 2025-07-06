#!/bin/bash

# Start Minikube cluster
echo "Starting Minikube cluster 'edc-standalone'..."

# Check if cluster already exists
if minikube status -p edc-standalone >/dev/null 2>&1; then
    echo "Cluster 'edc-standalone' already exists, starting it..."
    minikube start -p edc-standalone
else
    echo "Creating new Minikube cluster 'edc-standalone'..."
    minikube start \
        --driver=docker \
        --cpus=4 \
        --memory=8192 \
        -p edc-standalone
fi

# Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
minikube status -p edc-standalone

echo "Minikube cluster 'edc-standalone' is ready!" 