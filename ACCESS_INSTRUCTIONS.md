# Access Instructions for EDC Standalone and Monitoring Services

This document provides detailed instructions for accessing the EDC (Eclipse Dataspace Connector) services and monitoring stack (Grafana, Prometheus, Loki) after deployment.

## Prerequisites

Before accessing the services, ensure:
1. The cluster is running and accessible
2. EDC and monitoring stack are deployed successfully
3. Ingress controller is enabled and working
4. Minikube tunnel is running (for local development)

## Service Access Methods

### Method 1: Ingress (Recommended for Production)

The services are configured with ingress rules for external access.

#### Step 1: Start Minikube Tunnel (Local Development)
```bash
# Start minikube tunnel in a separate terminal
minikube tunnel
```

#### Step 2: Add Host Entries
Add the following entries to your `/etc/hosts` file:
```bash
sudo nano /etc/hosts
```

Add these lines:
```
127.0.0.1 edc-control.local
127.0.0.1 edc-data.local
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
```

### Method 2: Port Forwarding (Alternative)

If ingress is not working, you can use port forwarding:

```bash
# EDC Control Plane
kubectl port-forward -n edc-standalone svc/edc-control-plane 8181:8181

# EDC Data Plane
kubectl port-forward -n edc-standalone svc/edc-data-plane 8182:8181

# Grafana
kubectl port-forward -n edc-monitoring svc/grafana 3000:3000

# Prometheus
kubectl port-forward -n edc-monitoring svc/prometheus 9090:9090
```

## Service Access URLs

### EDC Services

#### 1. EDC Control Plane
- **URL**: http://edc-control.local:8181
- **Alternative**: http://localhost:8181 (with port forwarding)
- **Purpose**: Management API, contract negotiations, policy management
- **Authentication**: API Key required for most endpoints
- **API Key**: `edc-api-key`

#### 2. EDC Data Plane
- **URL**: http://edc-data.local:8181
- **Alternative**: http://localhost:8182 (with port forwarding)
- **Purpose**: Data transfer, asset access
- **Authentication**: API Key required for most endpoints
- **API Key**: `edc-peer-api-key`

### Monitoring Services

#### 1. Grafana
- **URL**: http://grafana.local:3000
- **Alternative**: http://localhost:3000 (with port forwarding)
- **Username**: `admin`
- **Password**: `admin123`
- **Purpose**: Dashboard and visualization for metrics and logs

#### 2. Prometheus
- **URL**: http://prometheus.local:9090
- **Alternative**: http://localhost:9090 (with port forwarding)
- **Purpose**: Metrics collection and querying
- **Authentication**: None (read-only)

## API Access Examples

### EDC Control Plane API

#### Health Check
```bash
# Health check (no authentication required)
curl -X GET http://edc-control.local:8181/api/check/health

# With port forwarding
curl -X GET http://localhost:8181/api/check/health
```

#### Authenticated Endpoints
```bash
# Set API key
export EDC_API_KEY="edc-api-key"

# Get connector information
curl -X GET http://edc-control.local:8181/api/v1/connectors \
  -H "X-Api-Key: $EDC_API_KEY"

# List assets
curl -X GET http://edc-control.local:8181/api/v1/assets \
  -H "X-Api-Key: $EDC_API_KEY"

# List contracts
curl -X GET http://edc-control.local:8181/api/v1/contracts \
  -H "X-Api-Key: $EDC_API_KEY"
```

### EDC Data Plane API

#### Health Check
```bash
# Health check (no authentication required)
curl -X GET http://edc-data.local:8181/api/check/health

# With port forwarding
curl -X GET http://localhost:8182/api/check/health
```

#### Authenticated Endpoints
```bash
# Set API key
export EDC_PEER_API_KEY="edc-peer-api-key"

# Data transfer endpoints
curl -X GET http://edc-data.local:8181/api/v1/data \
  -H "X-Api-Key: $EDC_PEER_API_KEY"
```

## Grafana Access and Configuration

### Initial Login
1. Navigate to http://grafana.local:3000
2. Login with:
   - **Username**: `admin`
   - **Password**: `admin123`

### Pre-configured Data Sources
The following data sources are automatically configured:
- **Prometheus**: http://prometheus:9090
- **Loki**: http://loki:3100

### Available Dashboards
- **EDC Metrics**: Pre-configured dashboard for EDC metrics
- **System Metrics**: Kubernetes and system-level metrics
- **Logs**: Centralized log viewing through Loki

### Creating Custom Dashboards
1. Click the "+" icon in the sidebar
2. Select "Dashboard"
3. Add panels and configure data sources
4. Save the dashboard

## Troubleshooting

### Common Issues

#### 1. Services Not Accessible
```bash
# Check if pods are running
kubectl get pods -n edc-standalone
kubectl get pods -n edc-monitoring

# Check ingress status
kubectl get ingress -A

# Check services
kubectl get svc -A
```

#### 2. Minikube Tunnel Issues
```bash
# Stop existing tunnel
sudo pkill -f "minikube tunnel"

# Start fresh tunnel
minikube tunnel
```

#### 3. Port Forwarding Issues
```bash
# Check if ports are already in use
netstat -tulpn | grep :8181
netstat -tulpn | grep :3000

# Kill processes using the ports if needed
sudo kill -9 <PID>
```

#### 4. Authentication Issues
```bash
# Verify API keys are correct
kubectl get secret -n edc-standalone edc-standalone-secret -o yaml

# Check EDC logs for authentication errors
kubectl logs -f deployment/edc-control-plane -n edc-standalone
```

### Health Check Commands

#### EDC Health Checks
```bash
# Control Plane Health
curl -X GET http://edc-control.local:8181/api/check/health

# Data Plane Health
curl -X GET http://edc-data.local:8181/api/check/health

# Expected Response: {"status": "healthy"}
```

#### Monitoring Health Checks
```bash
# Grafana Health
curl -X GET http://grafana.local:3000/api/health

# Prometheus Health
curl -X GET http://prometheus.local:9090/-/healthy

# Expected Response: {"status": "ok"} for Grafana, "OK" for Prometheus
```

## Security Notes

1. **API Keys**: Keep API keys secure and rotate them regularly
2. **Network Access**: Consider using network policies to restrict access
3. **TLS**: For production, enable TLS in ingress configuration
4. **Authentication**: Implement proper authentication mechanisms for production use

## Production Considerations

For production deployment:
1. Use proper TLS certificates
2. Implement strong authentication
3. Configure network policies
4. Set up monitoring alerts
5. Use persistent storage for Grafana and Prometheus
6. Implement proper backup strategies

## Support

If you encounter issues:
1. Check the pod logs: `kubectl logs -f <pod-name> -n <namespace>`
2. Verify service status: `kubectl get svc -n <namespace>`
3. Check ingress configuration: `kubectl describe ingress -n <namespace>`
4. Review the deployment scripts and Helm charts for configuration issues 