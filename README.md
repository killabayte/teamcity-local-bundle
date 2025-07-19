# TeamCity Kubernetes Helm Chart

A production-ready Helm chart for deploying TeamCity Server and Agents on Kubernetes.

## Features

- **TeamCity Server** with PostgreSQL database
- **TeamCity Agents** (configurable replica count)
- **Ingress support** with NGINX controller
- **Persistent storage** for TeamCity data and PostgreSQL
- **Proper networking** with internal service communication
- **Security** with proper secrets management

## Prerequisites

- Kubernetes cluster (tested with Kind)
- NGINX Ingress Controller
- Helm 3.x
- kubectl configured

## Project Structure

```
teamcity-k8s-instalations/
├── Chart.yaml              # Helm chart metadata
├── values.yaml             # Default configuration values
├── README.md              # This documentation
├── templates/              # Kubernetes manifests
│   ├── ingress.yaml
│   ├── teamcity-server-deployment.yaml
│   ├── teamcity-agent-deployment.yaml
│   └── ...
└── utils/                  # Utility scripts and documentation
    ├── deploy.sh           # Automated deployment script
    ├── kind-startup-config.yaml # Kind cluster configuration (2 nodes, port 8080)
    ├── TROUBLESHOOTING.md  # Common issues and solutions
    └── KIND_INGRESS_SETUP.md # Kind cluster setup guide
```

## Quick Start

### Option 1: Interactive Deployment (Recommended)

```bash
# Run the interactive deployment script
./utils/deploy.sh
```

### Option 2: Step-by-Step Deployment

```bash
# Create Kind cluster
./utils/deploy.sh kind

# Install NGINX Ingress Controller
./utils/deploy.sh ingress

# Deploy TeamCity
./utils/deploy.sh teamcity
```

### Option 3: Complete Setup

```bash
# Run all steps at once
./utils/deploy.sh all
```

### Option 4: Manual Deployment

#### 1. Install NGINX Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

#### 2. Install TeamCity

```bash
# Add to /etc/hosts for local development
echo "127.0.0.1 teamcity.local" | sudo tee -a /etc/hosts

# Install the chart
helm install teamcity . -f values.yaml

# Port forward for Kind clusters
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

### 3. Access TeamCity

- **URL**: http://teamcity.local:8080
- **Default**: No authentication required initially

### 4. Authorize Agents

1. Go to Agents page in TeamCity UI
2. Authorize the 2 agents that registered automatically
3. Agents will show as "Connected" and "Ready"

## Configuration

### values.yaml

```yaml
# TeamCity Server Configuration
server:
  nodeId: main
  publicUrl: http://teamcity.local
  extraJvmOpts: ""

# Ingress Configuration
ingress:
  enabled: true
  className: nginx
  host: teamcity.local
  path: /
  annotations: {}
  tls: []

# Database Configuration
database:
  name: teamcity
  user: teamcity
  password: "teamcitypass"

# Agent Configuration
replicaCount:
  agent: 2

# Persistence
persistence:
  teamcity:
    size: 10Gi
    storageClass: ""
  postgres:
    size: 5Gi
    storageClass: ""
```

## Troubleshooting

For detailed troubleshooting information, see `utils/TROUBLESHOOTING.md`.

### Quick Fixes

#### Ingress Not Working (Kind Clusters)

For Kind clusters, use port forwarding:

```bash
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

#### Agents Not Connecting

1. Check agent logs: `kubectl logs -l app=teamcity-teamcity,component=agent`
2. Verify agents are authorized in TeamCity UI
3. Check server logs: `kubectl logs -l app=teamcity-teamcity,component=server`

#### Database Issues

```bash
# Check PostgreSQL pod
kubectl get pods -l app=teamcity-teamcity,component=postgresql

# Check PostgreSQL logs
kubectl logs -l app=teamcity-teamcity,component=postgresql
```

For Kind cluster specific issues, see `utils/KIND_INGRESS_SETUP.md`.

## Production Considerations

### Security

1. **Change default passwords** in values.yaml
2. **Enable TLS** for ingress
3. **Use proper secrets** for database credentials
4. **Configure authentication** in TeamCity

### Scaling

1. **Increase agent replicas**: `replicaCount.agent: 5`
2. **Add resource limits** to values.yaml
3. **Use persistent storage** for agent workspaces

### Monitoring

1. **Add Prometheus annotations**
2. **Configure logging** aggregation
3. **Set up health checks**

## Utils Directory

The `utils/` directory contains helpful scripts and documentation:

### deploy.sh
Modular deployment script with interactive prompts:
- **kind** - Create Kind cluster with 2 worker nodes and port 8080 exposed
- **ingress** - Install NGINX Ingress Controller
- **teamcity** - Deploy TeamCity to the cluster
- **all** - Run complete setup (kind + ingress + teamcity)
- **Interactive mode** - Choose what to install with prompts

Usage examples:
```bash
./utils/deploy.sh kind      # Only create Kind cluster
./utils/deploy.sh ingress   # Only install ingress controller
./utils/deploy.sh teamcity  # Only deploy TeamCity
./utils/deploy.sh all       # Complete setup
./utils/deploy.sh           # Interactive mode
```

### TROUBLESHOOTING.md
Comprehensive troubleshooting guide covering:
- Ingress issues and solutions
- Agent connection problems
- Database connectivity issues
- Common error messages and fixes

### KIND_INGRESS_SETUP.md
Specialized guide for Kind clusters:
- Port forwarding solutions
- Kind cluster configuration
- MetalLB setup for LoadBalancer support
- Alternative access methods

## Development

### Local Development

```bash
# Install chart locally
helm install teamcity . -f values.yaml

# Upgrade chart
helm upgrade teamcity . -f values.yaml

# Uninstall
helm uninstall teamcity
```

### Testing

```bash
# Lint the chart
helm lint .

# Template the chart
helm template teamcity . -f values.yaml

# Dry run install
helm install teamcity . -f values.yaml --dry-run
```

## Version History

- **v1.0.0**: Initial working version with ingress and agents
- Fixed ingress configuration for Kind clusters
- Proper agent-server communication via internal services

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `helm lint .` and `helm template .`
5. Submit a pull request

## License

MIT License 
