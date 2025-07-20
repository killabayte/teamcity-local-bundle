# TeamCity Kubernetes Helm Chart

A production-ready Helm chart for deploying TeamCity Server and Agents on Kubernetes with automated deployment scripts.

## Features

- **TeamCity Server** with PostgreSQL database
- **TeamCity Agents** (configurable replica count)
- **Ingress support** with NGINX controller
- **Persistent storage** for TeamCity data and PostgreSQL
- **Single-node Kind cluster** for reliable deployment
- **Automated deployment scripts** with modular options
- **Namespace separation** for better resource isolation
- **Fallback deployment** for large Helm charts

## Prerequisites

- Kubernetes cluster (tested with Kind)
- NGINX Ingress Controller
- Helm 3.x
- kubectl configured
- kind (for local development)

## Project Structure

```
teamcity-k8s-instalations/
├── Chart.yaml                    # Helm chart metadata
├── values.yaml                   # Default configuration values
├── README.md                     # This documentation
├── CHANGELOG.md                  # Version history and changes
├── templates/                    # Kubernetes manifests
│   ├── namespaces.yaml          # Namespace definitions
│   ├── ingress.yaml             # Ingress configuration
│   ├── teamcity-server-deployment.yaml
│   ├── teamcity-server-service.yaml
│   ├── teamcity-server-pvc.yaml
│   ├── teamcity-agent-deployment.yaml
│   ├── postgres-deployment.yaml
│   ├── postgres-service.yaml
│   ├── postgres-pvc.yaml
│   └── secret.yaml
└── utils/                        # Utility scripts
    ├── deploy.sh                 # Automated deployment script
    ├── kind-startup-config.yaml  # Kind cluster configuration
    └── TROUBLESHOOTING.md       # Troubleshooting guide
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

**Important**: For Kind clusters, you need to port-forward the ingress controller:

```bash
# Port forward the ingress controller to access on port 8080
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

Then access TeamCity at `http://teamcity.local:8080`

### 4. Authorize Agents

1. Go to Agents page in TeamCity UI
2. Authorize the 2 agents that registered automatically
3. Agents will show as "Connected" and "Ready"

## Configuration

### values.yaml

```yaml
image:
  server: "jetbrains/teamcity-server:latest"
  agent:  "jetbrains/teamcity-agent:latest"
pullPolicy: IfNotPresent

replicaCount:
  agent: 2

server:
  nodeId: main
  publicUrl: http://teamcity.local
  extraJvmOpts: ""

ingress:
  enabled: true
  className: nginx
  host: teamcity.local
  path: /
  annotations: {}
  tls: []

database:
  name: teamcity
  user: teamcity
  password: "teamcitypass"

persistence:
  teamcity:
    size: 10Gi
    storageClass: ""
  postgres:
    size: 5Gi
    storageClass: ""
```

## Deployment Script

The `utils/deploy.sh` script provides modular deployment options:

### Available Commands

- **`kind`** - Create Kind cluster with single node and port 8080 exposed
- **`ingress`** - Install NGINX Ingress Controller
- **`teamcity`** - Deploy TeamCity to the cluster
- **`all`** - Run all steps (kind + ingress + teamcity)
- **`cleanup`** - Delete Kind cluster 'kansas'
- **`help`** - Show help message

### Usage Examples

```bash
./utils/deploy.sh kind      # Only create Kind cluster
./utils/deploy.sh ingress   # Only install ingress controller
./utils/deploy.sh teamcity  # Only deploy TeamCity
./utils/deploy.sh all       # Complete setup
./utils/deploy.sh cleanup   # Delete Kind cluster
./utils/deploy.sh           # Interactive mode
```

### Features

- **Interactive mode** with prompts for beginners
- **Modular deployment** for step-by-step setup
- **Automatic fallback** from Helm to kubectl apply
- **Prerequisites checking** for required tools
- **Colored output** for better user experience
- **Error handling** with helpful messages

## Kind Cluster Configuration

The Kind cluster is configured as a single-node setup for reliability:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
```

**Benefits of single-node setup:**
- Eliminates cross-namespace communication issues
- Simpler networking architecture
- More reliable agent connections
- Easier debugging and monitoring

## Troubleshooting

For detailed troubleshooting information, see `utils/TROUBLESHOOTING.md`.

### Quick Fixes

#### Ingress Not Working (Kind Clusters)

For Kind clusters, you need to port-forward the ingress controller:

```bash
# Port forward the ingress controller to access on port 8080
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

**Why this is needed**: Kind clusters don't automatically expose NodePorts to the host machine. The ingress controller runs on NodePorts internally, but you need port forwarding to access them from your local machine.

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

#### Helm Installation Issues

The deployment script automatically handles large Helm charts by falling back to kubectl apply:

```bash
# Manual fallback if needed
helm template teamcity . -f values.yaml | kubectl apply -f -
```

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

- **v0.2.5**: Clean up chart formatting and documentation
- **v0.2.4**: Switch to single-node Kind cluster to resolve cross-namespace communication issues
- **v0.2.3**: Implement fallback deployment for large Helm charts
- **v0.2.0**: Initial modular deployment script with interactive prompts

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `helm lint .` and `helm template .`
5. Submit a pull request

## License

MIT License 
