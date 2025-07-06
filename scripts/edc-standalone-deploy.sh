#!/bin/bash

# Deploy EDC Standalone Only
set -e

echo "🚀 Deploying EDC Standalone..."

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

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster. Please check your cluster configuration."
    exit 1
fi

# Create EDC standalone namespace if it doesn't exist
echo "📦 Creating EDC standalone namespace..."
kubectl create namespace edc-standalone --dry-run=client -o yaml | kubectl apply -f -

# Deploy EDC standalone
echo "🔗 Deploying EDC standalone..."
helm upgrade --install edc-standalone ./helm/edc-standalone \
    --namespace edc-standalone \
    --create-namespace \
    --wait \
    --timeout=10m

# Wait for pods to be ready
echo "⏳ Waiting for EDC pods to be ready..."
kubectl wait --for=condition=ready pod -l app=edc-control-plane -n edc-standalone --timeout=300s
kubectl wait --for=condition=ready pod -l app=edc-data-plane -n edc-standalone --timeout=300s
kubectl wait --for=condition=ready pod -l app=edc-peer-control-plane -n edc-standalone --timeout=300s
kubectl wait --for=condition=ready pod -l app=edc-peer-data-plane -n edc-standalone --timeout=300s

echo "✅ EDC Standalone deployed successfully!"
echo ""
echo "📋 EDC Status:"
kubectl get pods -n edc-standalone
echo ""
echo "🌐 Access URLs (add to /etc/hosts for local access):"
echo "   EDC Control Plane: http://edc-control.local"
echo "   EDC Data Plane:    http://edc-data.local"
echo ""
echo "🔍 To check logs:"
echo "   EDC: kubectl logs -f deployment/edc-control-plane -n edc-standalone" 