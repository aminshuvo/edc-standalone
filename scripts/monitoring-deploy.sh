#!/bin/bash

# Deploy Monitoring Stack Only
set -e

echo "🚀 Deploying Monitoring Stack..."

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

# Create monitoring namespace if it doesn't exist
echo "📦 Creating monitoring namespace..."
kubectl create namespace edc-monitoring --dry-run=client -o yaml | kubectl apply -f -

# Deploy monitoring stack
echo "📊 Deploying monitoring stack..."
helm upgrade --install edc-monitoring ./helm/edc-monitoring \
    --namespace edc-monitoring \
    --create-namespace \
    --wait \
    --timeout=10m

# Wait for pods to be ready
echo "⏳ Waiting for monitoring pods to be ready..."
kubectl wait --for=condition=ready pod -l app=prometheus -n edc-monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app=grafana -n edc-monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app=loki -n edc-monitoring --timeout=300s

echo "✅ Monitoring Stack deployed successfully!"
echo ""
echo "📋 Monitoring Stack Status:"
kubectl get pods -n edc-monitoring
echo ""
echo "🌐 Access URLs (add to /etc/hosts for local access):"
echo "   Prometheus: http://prometheus.local"
echo "   Grafana:    http://grafana.local (admin/admin123)"
echo ""
echo "🔍 To check logs:"
echo "   kubectl logs -f deployment/prometheus -n edc-monitoring"
echo "   kubectl logs -f deployment/grafana -n edc-monitoring"
echo "   kubectl logs -f deployment/loki -n edc-monitoring" 