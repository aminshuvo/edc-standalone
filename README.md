# Standalone Eclipse Dataspace Connector (EDC) Deployment

This project provisions a standalone EDC connector and monitoring stack using Helm and Kubernetes, demonstrating peer-to-peer data exchange capabilities with a complete observability stack.

## Architecture

- **EDC Standalone Connector**: Primary EDC instance in `edc-standalone` namespace
- **EDC Peer Connector**: Secondary EDC instance (deployed in the same `edc-standalone` namespace for simplicity)
- **Monitoring Stack**: Prometheus, Grafana, Loki, and Promtail for observability (deployed in `edc-monitoring` namespace)
- **Infrastructure**: Terraform-managed Minikube cluster with proper RBAC and ingress

## Project Structure

```
edc-standalone/
├── helm/
│   ├── edc-standalone/         # Helm chart for EDC standalone and peer
│   └── edc-monitoring/         # Helm chart for monitoring stack (Prometheus, Grafana, Loki, Promtail)
├── config/                     # Reference configuration files
├── scripts/                    # Deployment and cleanup scripts
│   ├── deploy-all.sh          # Deploy EDC and monitoring stack
│   ├── clean-all.sh           # Clean up all resources
│   ├── edc-standalone-deploy.sh    # Deploy EDC standalone only
│   ├── edc-standalone-cleanup.sh   # Clean up EDC standalone only
│   ├── monitoring-deploy.sh        # Deploy monitoring stack only
│   └── monitoring-cleanup.sh       # Clean up monitoring stack only
├── terraform/                  # Infrastructure as Code
└── README.md                   # This file
```

## Prerequisites

### Required Tools and Versions

- **Minikube**: v1.36.0 or later
- **kubectl**: v1.33.1 or later  
- **Helm**: v3.18.3 or later
- **Terraform**: v1.12.2 or later

### Installation Links

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/)
- [Terraform](https://www.terraform.io/downloads.html)

## Deployment

1. **Provision the cluster with Terraform** (if not already running):
   ```bash
   cd terraform
   terraform init
   terraform apply
   cd ..
   ```

2. **Deploy EDC and monitoring stack:**
   ```bash
   ./scripts/deploy-all.sh
   ```
   This will deploy:
   - EDC standalone and peer in the `edc-standalone` namespace
   - Monitoring stack (Prometheus, Grafana, Loki, Promtail) in the `edc-monitoring` namespace

### Alternative Deployment Options

You can also deploy components individually:

```bash
# Deploy EDC standalone only
./scripts/edc-standalone-deploy.sh

# Deploy monitoring stack only  
./scripts/monitoring-deploy.sh
```

3. **Access the services:**
   - EDC Control Plane: http://edc-control.local
   - EDC Data Plane: http://edc-data.local
   - Prometheus: http://prometheus.local
   - Grafana: http://grafana.local (admin/admin123)

   > Add these hostnames to your `/etc/hosts` file if running locally.
   > 
   > **📖 For detailed access instructions, see [ACCESS_INSTRUCTIONS.md](ACCESS_INSTRUCTIONS.md)**

## Monitoring and Logging

- **Prometheus** scrapes metrics from all EDC pods in the `edc-standalone` namespace.
- **Promtail** collects logs from all EDC pods and ships them to **Loki** in the `edc-monitoring` namespace.
- **Grafana** is automatically provisioned with both Prometheus and Loki as data sources, and includes a sample dashboard.

## Cleanup

### Full Cleanup

To remove all resources:
```bash
./scripts/clean-all.sh
```

This will clean up:
- All EDC resources in the `edc-standalone` namespace
- All monitoring resources in the `edc-monitoring` namespace
- Helm releases and associated resources

### Selective Cleanup

You can also clean up components individually:

```bash
# Clean up EDC standalone only
./scripts/edc-standalone-cleanup.sh

# Clean up monitoring stack only
./scripts/monitoring-cleanup.sh
```

## Script Usage Guide

### Deployment Scripts
- `deploy-all.sh` - Deploy everything (EDC + monitoring) - **Recommended for first-time setup**
- `edc-standalone-deploy.sh` - Deploy EDC standalone only
- `monitoring-deploy.sh` - Deploy monitoring stack only

### Cleanup Scripts
- `clean-all.sh` - Clean up everything (EDC + monitoring) - **Recommended for complete cleanup**
- `edc-standalone-cleanup.sh` - Clean up EDC standalone only
- `monitoring-cleanup.sh` - Clean up monitoring stack only

## Quick Access Reference

### EDC Services
- **Control Plane**: http://edc-control.local:8181 (API Key: `edc-api-key`)
- **Data Plane**: http://edc-data.local:8181 (API Key: `edc-peer-api-key`)

### Monitoring Services
- **Grafana**: http://grafana.local:3000 (admin/admin123)
- **Prometheus**: http://prometheus.local:9090

### Health Checks
```bash
# EDC Health
curl http://edc-control.local:8181/api/check/health
curl http://edc-data.local:8181/api/check/health

# Grafana Health
curl http://grafana.local:3000/api/health
```

## Notes
- All deployment is now managed via Helm charts for better maintainability and consistency.
- Both EDC standalone and peer are deployed in the same namespace for simplicity. You can split them if needed by adjusting the Helm values.
- The monitoring stack is fully separated and can be managed independently.
- Reference configuration files are available in the `config/` directory.
- **📖 For comprehensive access instructions, see [ACCESS_INSTRUCTIONS.md](ACCESS_INSTRUCTIONS.md)**

---
For further customization or troubleshooting, see the comments in the respective Helm chart `values.yaml` files. 