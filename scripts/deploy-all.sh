#!/bin/bash

# Deploy EDC Standalone with Helm
set -e

echo "🚀 Deploying EDC Standalone with Monitoring..."

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

# Create namespaces if they don't exist
echo "📦 Creating namespaces..."
kubectl create namespace edc-standalone --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace edc-monitoring --dry-run=client -o yaml | kubectl apply -f -

# Deploy monitoring stack first
echo "📊 Deploying monitoring stack..."
helm upgrade --install edc-monitoring ./helm/edc-monitoring \
    --namespace edc-monitoring \
    --create-namespace \
    --wait \
    --timeout=10m

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

echo "⏳ Waiting for monitoring pods to be ready..."
kubectl wait --for=condition=ready pod -l app=prometheus -n edc-monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app=grafana -n edc-monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app=loki -n edc-monitoring --timeout=300s

echo "✅ EDC Standalone with Monitoring deployed successfully!"
echo ""
echo "📋 EDC Status:"
kubectl get pods -n edc-standalone
echo ""
echo "📋 Monitoring Status:"
kubectl get pods -n edc-monitoring
echo ""
echo "🌐 Access URLs (add to /etc/hosts for local access):"
echo "   EDC Control Plane: http://edc-control.local"
echo "   EDC Data Plane:    http://edc-data.local"
echo "   Prometheus:        http://prometheus.local"
echo "   Grafana:           http://grafana.local (admin/admin123)"
echo ""
echo "🔍 To check logs:"
echo "   EDC: kubectl logs -f deployment/edc-control-plane -n edc-standalone"
echo "   Monitoring: kubectl logs -f deployment/prometheus -n edc-monitoring" 