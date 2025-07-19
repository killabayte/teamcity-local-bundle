# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2025-07-19

### Added
- Initial TeamCity Helm chart with PostgreSQL database
- TeamCity server deployment with persistent storage
- TeamCity agents deployment (configurable replica count)
- NGINX Ingress Controller integration
- Kind cluster configuration with 2 worker nodes
- Modular deployment script with interactive prompts
- Comprehensive documentation and troubleshooting guides
- Port forwarding support for Kind clusters
- Wizard of Oz themed cluster naming (kansas)

### Features
- Complete TeamCity CI/CD setup
- Multi-agent support with auto-registration
- Persistent storage for TeamCity and PostgreSQL
- Ingress controller with proper header forwarding
- Interactive deployment script with modular options
- Kind cluster optimization with port 8080 support

### Technical Details
- Helm chart version: 0.1.0
- TeamCity server: jetbrains/teamcity-server:latest
- TeamCity agents: jetbrains/teamcity-agent:latest
- Database: PostgreSQL with persistent storage
- Ingress: NGINX with host teamcity.local
- Default agents: 2 replicas
- Cluster name: kansas

### Installation
```bash
# Interactive deployment
./utils/deploy.sh

# Step-by-step deployment
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity
```

### Access
```bash
# Port forward for Kind clusters
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

# Access at http://teamcity.local:8080
```

### Known Issues
- Kind clusters require port forwarding for ingress access
- TeamCity agents need manual authorization in UI
- Initial setup requires TeamCity wizard completion

### Files Added
- Chart.yaml - Helm chart metadata
- values.yaml - Default configuration values
- templates/ - Kubernetes manifests
- utils/deploy.sh - Interactive deployment script
- utils/kind-startup-config.yaml - Kind cluster configuration
- utils/TROUBLESHOOTING.md - Troubleshooting guide
- README.md - Comprehensive documentation

### Package
- Chart package: teamcity-0.1.0.tgz
- Git tag: v0.1.0 
