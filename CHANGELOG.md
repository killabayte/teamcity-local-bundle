# Changelog

All notable changes to this project will be documented in this file.

## [0.2.4] - 2025-07-19

### Fixed
- Resolved cross-namespace communication issues by switching to single-node Kind cluster
- Eliminated "Disconnected — Cannot access agent" timeout problems
- Simplified networking architecture for better reliability

### Changed
- Updated Kind cluster configuration to use single control-plane node
- Simplified deploy script to reflect single-node setup
- Removed multi-node complexity that caused networking issues

### Features
- Single-node Kind cluster for improved reliability
- Eliminated cross-namespace communication problems
- Simplified deployment architecture

### Technical Details
- Helm chart version: 0.2.4
- Kind cluster: Single control-plane node
- All components run on same node for optimal communication
- No cross-namespace networking issues

### Installation
```bash
# Deploy with single-node Kind cluster
./utils/deploy.sh all

# Or step by step
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity
```

### Benefits
- ✅ No cross-namespace communication issues
- ✅ Eliminated timeout problems
- ✅ Simpler networking architecture
- ✅ More reliable agent connections
- ✅ Easier debugging and monitoring

### Files Modified
- utils/kind-startup-config.yaml - Simplified to single node
- utils/deploy.sh - Updated for single-node setup
- templates/teamcity-agent-deployment.yaml - Enhanced timeout settings

### Package
- Chart package: teamcity-0.2.4.tgz
- Git tag: v0.2.4

## [0.2.3] - 2025-07-19

### Fixed
- Resolved Helm release secret size limit error during installation
- Implemented fallback to kubectl apply method when Helm installation fails
- Enhanced deploy script to handle large chart deployments gracefully

### Changed
- Updated deploy script to try Helm installation first, then fallback to kubectl apply
- Added automatic namespace creation in fallback method
- Improved error handling for deployment failures

### Features
- Smart deployment fallback system
- Automatic handling of Helm release secret size limitations
- Enhanced deployment reliability

### Technical Details
- Helm chart version: 0.2.3
- Fallback method: `helm template | kubectl apply -f -`
- Automatic namespace creation in fallback mode
- Maintains all existing functionality while improving reliability

### Installation
```bash
# Deploy with automatic fallback
./utils/deploy.sh teamcity

# Manual fallback if needed
helm template teamcity . | kubectl apply -f -
```

### Known Issues
- Helm release secret size limit (now handled automatically)
- Kind clusters require port forwarding for ingress access
- TeamCity agents need manual authorization in UI

### Files Modified
- utils/deploy.sh - Added fallback deployment logic
- Chart.yaml - Updated version to 0.2.3

### Package
- Chart package: teamcity-0.2.3.tgz
- Git tag: v0.2.3

## [0.2.1] - 2025-07-19

### Changed
- Simplified cleanup functionality to only delete Kind cluster
- Removed duplicate cleanup options
- Updated documentation to reflect simplified cleanup

### Features
- `./utils/deploy.sh cleanup` - Delete Kind cluster 'kansas' (simplified)

### Technical Details
- Helm chart version: 0.2.1
- Simplified cleanup operations

## [0.2.0] - 2025-07-19

### Added
- Cleanup functionality in deploy script
- Namespace separation for TeamCity components
- Kind cluster cleanup option
- Enhanced deployment status reporting

### Changed
- TeamCity server now deployed in `teamcity-server` namespace
- TeamCity agents now deployed in `teamcity-agents` namespace
- Updated agent configuration to connect across namespaces
- Enhanced cleanup to remove namespaces

### Features
- `./utils/deploy.sh cleanup` - Delete Kind cluster 'kansas'
- Separate namespaces for better resource isolation
- Cross-namespace communication between agents and server

### Technical Details
- Helm chart version: 0.2.0
- Server namespace: teamcity-server
- Agents namespace: teamcity-agents
- Agent server URL: `http://teamcity-teamcity-server.teamcity-server.svc.cluster.local:8111`

### Installation
```bash
# Interactive deployment
./utils/deploy.sh

# Step-by-step deployment
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity

# Cleanup options
./utils/deploy.sh cleanup
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
- templates/namespaces.yaml - Namespace definitions
- Updated all templates with namespace specifications

### Package
- Chart package: teamcity-0.2.0.tgz
- Git tag: v0.2.0

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
