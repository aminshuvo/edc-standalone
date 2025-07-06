#!/bin/bash

# Cleanup EDC Standalone Only
set -e

echo "🧹 Cleaning up EDC Standalone..."

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

# Delete EDC standalone namespace
echo "🗑️  Deleting EDC standalone namespace..."
kubectl delete namespace edc-standalone --ignore-not-found=true

echo "✅ EDC Standalone cleanup completed!" 