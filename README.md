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

## Quick Start

### 1. Install NGINX Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

### 2. Install TeamCity

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

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Ingress       │    │  TeamCity       │    │  PostgreSQL     │
│   (NGINX)       │    │  Server         │    │  Database       │
│                 │    │                 │    │                 │
│  Port 80/443    │◄──►│  Port 8111     │◄──►│  Port 5432     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌─────────────────┐
                       │  TeamCity       │
                       │  Agents         │
                       │                 │
                       │  Port 9090      │
                       └─────────────────┘
```

## Troubleshooting

### Ingress Not Working (Kind Clusters)

For Kind clusters, use port forwarding:

```bash
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

### Agents Not Connecting

1. Check agent logs: `kubectl logs -l app=teamcity-teamcity,component=agent`
2. Verify agents are authorized in TeamCity UI
3. Check server logs: `kubectl logs -l app=teamcity-teamcity,component=server`

### Database Issues

```bash
# Check PostgreSQL pod
kubectl get pods -l app=teamcity-teamcity,component=postgresql

# Check PostgreSQL logs
kubectl logs -l app=teamcity-teamcity,component=postgresql
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
