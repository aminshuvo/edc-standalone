#!/bin/bash

# Cleanup EDC Standalone and Monitoring
set -e

echo "🧹 Cleaning up EDC Standalone and Monitoring..."

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

# Uninstall EDC standalone
echo "🗑️  Uninstalling EDC standalone..."
helm uninstall edc-standalone -n edc-standalone || true

# Uninstall monitoring stack
echo "🗑️  Uninstalling monitoring stack..."
helm uninstall edc-monitoring -n edc-monitoring || true

# Delete namespaces
echo "🗑️  Deleting namespaces..."
kubectl delete namespace edc-standalone --ignore-not-found=true
kubectl delete namespace edc-monitoring --ignore-not-found=true

echo "✅ EDC Standalone and Monitoring cleanup completed!" 