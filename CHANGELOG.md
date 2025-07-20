# Changelog

All notable changes to this project will be documented in this file.

## [0.2.6] - 2025-07-19

### Changed
- Updated README.md to accurately reflect all current files and functionality
- Added comprehensive deployment script documentation
- Included Kind cluster configuration details
- Updated project structure to match actual files
- Added current version history and features

### Files Modified
- README.md - Complete rewrite to match current project state
- Chart.yaml - Updated version to 0.2.6

### Technical Details
- Helm chart version: 0.2.6
- Accurate project structure documentation
- Complete deployment script reference
- Current functionality documentation

### Package
- Chart package: teamcity-0.2.6.tgz
- Git tag: v0.2.6

## [0.2.5] - 2025-07-19

### Changed
- Cleaned up chart formatting and documentation
- Removed excessive comment blocks and formatting
- Simplified code comments throughout the chart
- Improved code readability and professionalism

### Files Modified
- values.yaml - Removed comment blocks
- templates/teamcity-server-deployment.yaml - Cleaned up JVM flags section
- templates/teamcity-agent-deployment.yaml - Removed excessive inline comments
- templates/ingress.yaml - Simplified comment structure
- CHANGELOG.md - Removed emoji formatting, made more natural

### Technical Details
- Helm chart version: 0.2.5
- Improved code readability and professionalism
- Maintained all functionality while cleaning up presentation
- More maintainable and human-readable codebase

### Package
- Chart package: teamcity-0.2.5.tgz
- Git tag: v0.2.5

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
- No cross-namespace communication issues
- Eliminated timeout problems
- Simpler networking architecture
- More reliable agent connections
- Easier debugging and monitoring

### Files Modified
- utils/kind-startup-config.yaml - Simplified to single node
- utils/deploy.sh - Updated for single-node setup
- templates/teamcity-agent-deployment.yaml - Enhanced timeout settings

### Package
- Chart package: teamcity-0.2.4.tgz
- Git tag: v0.2.4

## [0.2.3] - 2025-07-19

### Fixed
- Resolved Helm release secret size limit exceeded error
- Fixed fallback deployment method for large charts
- Improved error handling in deploy script

### Changed
- Enhanced deploy script with better error detection
- Updated Helm installation to handle large release secrets
- Improved kubectl apply fallback method

### Features
- Automatic fallback from Helm install to kubectl apply
- Better error messages and status reporting
- More reliable deployment process

### Technical Details
- Helm chart version: 0.2.3
- Fallback method: helm template | kubectl apply -f -
- Handles charts that exceed Kubernetes secret size limits
- Improved deployment reliability

### Installation
```bash
# Deploy with automatic fallback
./utils/deploy.sh all

# Or step by step
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity
```

### Benefits
- Handles large Helm charts automatically
- More reliable deployment process
- Better error handling and reporting
- Automatic fallback when needed

### Files Modified
- utils/deploy.sh - Added Helm fallback logic
- Enhanced error handling and status reporting

### Package
- Chart package: teamcity-0.2.3.tgz
- Git tag: v0.2.3

## [0.2.2] - 2025-07-19

### Fixed
- Resolved namespace conflicts during Helm installation
- Fixed conditional namespace creation logic
- Improved namespace management in deploy script

### Changed
- Enhanced deploy script with better namespace handling
- Updated namespace creation to be conditional
- Improved error handling for namespace conflicts

### Features
- Conditional namespace creation
- Better namespace conflict resolution
- Improved deployment reliability

### Technical Details
- Helm chart version: 0.2.2
- Conditional namespace creation with --dry-run=client
- Better handling of existing namespaces
- Improved deployment process

### Installation
```bash
# Deploy with improved namespace handling
./utils/deploy.sh all

# Or step by step
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity
```

### Benefits
- No namespace conflicts during deployment
- More reliable namespace management
- Better error handling
- Improved deployment process

### Files Modified
- utils/deploy.sh - Enhanced namespace handling
- Improved error handling and status reporting

### Package
- Chart package: teamcity-0.2.2.tgz
- Git tag: v0.2.2

## [0.2.1] - 2025-07-19

### Fixed
- Resolved ingress controller detection issues
- Fixed ingress installation logic in deploy script
- Improved ingress controller status checking

### Changed
- Enhanced deploy script with better ingress detection
- Updated ingress installation process
- Improved error handling for ingress setup

### Features
- Better ingress controller detection
- Improved ingress installation process
- Enhanced error handling

### Technical Details
- Helm chart version: 0.2.1
- Better ingress controller detection logic
- Improved ingress installation process
- Enhanced error handling

### Installation
```bash
# Deploy with improved ingress handling
./utils/deploy.sh all

# Or step by step
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity
```

### Benefits
- More reliable ingress installation
- Better error handling
- Improved deployment process
- Enhanced status reporting

### Files Modified
- utils/deploy.sh - Enhanced ingress handling
- Improved error handling and status reporting

### Package
- Chart package: teamcity-0.2.1.tgz
- Git tag: v0.2.1

## [0.2.0] - 2025-07-19

### Added
- Modular deployment script with interactive prompts
- Kind cluster configuration with port 8080 exposed
- Comprehensive troubleshooting documentation
- Namespace separation for server and agents

### Changed
- Split deploy script into modular components
- Added interactive mode for deployment
- Enhanced error handling and status reporting
- Improved documentation structure

### Features
- Modular deployment script (kind, ingress, teamcity, all, cleanup)
- Interactive deployment mode with prompts
- Kind cluster with port 8080 exposed
- Namespace separation (teamcity-server, teamcity-agents)
- Comprehensive troubleshooting guides

### Technical Details
- Helm chart version: 0.2.0
- Kind cluster: 2 nodes (1 control-plane, 1 worker)
- Port mapping: 8080:80 for ingress access
- Namespaces: teamcity-server, teamcity-agents
- Interactive deployment script

### Installation
```bash
# Interactive deployment
./utils/deploy.sh

# Modular deployment
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity

# Complete setup
./utils/deploy.sh all

# Cleanup
./utils/deploy.sh cleanup
```

### Benefits
- Modular deployment options
- Interactive mode for beginners
- Better error handling
- Comprehensive documentation
- Namespace separation for security

### Files Added
- utils/deploy.sh - Modular deployment script
- utils/kind-startup-config.yaml - Kind cluster config
- utils/TROUBLESHOOTING.md - Troubleshooting guide
- utils/KIND_INGRESS_SETUP.md - Kind setup guide
- templates/namespaces.yaml - Namespace definitions

### Package
- Chart package: teamcity-0.2.0.tgz
- Git tag: v0.2.0

## [0.1.0] - 2025-07-19

### Added
- Initial TeamCity Helm chart
- TeamCity server deployment
- TeamCity agent deployment
- PostgreSQL database
- NGINX ingress controller
- Persistent storage support

### Features
- TeamCity server with PostgreSQL
- Multiple TeamCity agents
- Ingress support for external access
- Persistent storage for data
- Proper service communication

### Technical Details
- Helm chart version: 0.1.0
- TeamCity server with PostgreSQL
- Multiple agents with configurable replicas
- Ingress support with NGINX
- Persistent storage for data and database

### Installation
```bash
# Install the chart
helm install teamcity . -f values.yaml

# Access TeamCity
# URL: http://teamcity.local:8080
```

### Benefits
- Complete TeamCity setup
- Ingress support for external access
- Persistent storage for data
- Multiple agents for scalability

### Files Added
- Complete Helm chart structure
- TeamCity server and agent deployments
- PostgreSQL deployment
- Ingress configuration
- Service definitions

### Package
- Chart package: teamcity-0.1.0.tgz
- Git tag: v0.1.0 
