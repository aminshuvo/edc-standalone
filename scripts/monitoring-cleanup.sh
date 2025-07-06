#!/bin/bash

# Cleanup Monitoring Stack Only
set -e

echo "🧹 Cleaning up Monitoring Stack..."

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed. Please install Helm first."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Uninstall monitoring stack
echo "🗑️  Uninstalling monitoring stack..."
helm uninstall edc-monitoring -n edc-monitoring || true

# Delete monitoring namespace
echo "🗑️  Deleting monitoring namespace..."
kubectl delete namespace edc-monitoring --ignore-not-found=true

echo "✅ Monitoring Stack cleanup completed!" 