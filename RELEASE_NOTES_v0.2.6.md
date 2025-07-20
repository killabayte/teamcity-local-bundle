# TeamCity Helm Chart v0.2.6

## Release Notes

### What's New

This release includes comprehensive documentation updates and improved project structure representation.

### Changes

- **Updated README.md** to accurately reflect all current files and functionality
- **Added comprehensive deployment script documentation** with all available commands
- **Included Kind cluster configuration details** showing single-node setup
- **Updated project structure** to match actual files in the repository
- **Added current version history** and features documentation

### Technical Details

- **Helm chart version:** 0.2.6
- **Kind cluster:** Single control-plane node for reliability
- **Deployment script:** Modular options (kind, ingress, teamcity, all, cleanup)
- **Documentation:** Complete and accurate project representation

### Installation

```bash
# Quick start with interactive deployment
./utils/deploy.sh

# Or step by step
./utils/deploy.sh kind
./utils/deploy.sh ingress
./utils/deploy.sh teamcity

# Complete setup
./utils/deploy.sh all
```

### Features

- ✅ **Single-node Kind cluster** for reliable deployment
- ✅ **Automated deployment scripts** with modular options
- ✅ **Namespace separation** for better resource isolation
- ✅ **Fallback deployment** for large Helm charts
- ✅ **Comprehensive documentation** with accurate project structure

### Files Included

- `teamcity-0.2.6.tgz` - Helm chart package (111KB)
- `teamcity-helm-chart-v0.2.6.zip` - Source code archive (15KB)

### Previous Versions

- **v0.2.5:** Clean up chart formatting and documentation
- **v0.2.4:** Switch to single-node Kind cluster
- **v0.2.3:** Implement fallback deployment for large Helm charts
- **v0.2.0:** Initial modular deployment script

### Support

For issues and questions, please refer to the README.md file or create an issue in the repository. 
