# TeamCity Ingress Troubleshooting Guide

## Common Issues and Solutions

### 1. **Ingress Controller Not Installed**
If you're getting 404 errors or the ingress doesn't work at all:

```bash
# Check if NGINX ingress controller is installed
kubectl get pods -n ingress-nginx

# If not installed, install it:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

### 2. **DNS Resolution Issues**
The ingress is configured for `teamcity.local`. You need to:

**Option A: Add to /etc/hosts**
```bash
# Add this line to your /etc/hosts file
127.0.0.1 teamcity.local
```

**Option B: Use a different hostname**
Update `values.yaml`:
```yaml
ingress:
  host: your-actual-domain.com
```

### 3. **Check Ingress Status**
```bash
# Check if ingress is created
kubectl get ingress

# Check ingress details
kubectl describe ingress <release-name>-teamcity-ingress

# Check if the service is running
kubectl get pods -l app=<release-name>-teamcity
```

### 4. **Check Service Connectivity**
```bash
# Test service directly
kubectl port-forward svc/<release-name>-teamcity-server 8111:8111

# Then visit http://localhost:8111
```

### 5. **Check Logs**
```bash
# Check ingress controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

# Check TeamCity server logs
kubectl logs -l app=<release-name>-teamcity,component=server
```

### 6. **Common Configuration Issues**

**Wrong Ingress Class:**
Make sure your cluster has the correct ingress class. If you're using a different ingress controller, update:
```yaml
ingress:
  className: your-ingress-class
```

**TLS Configuration:**
If you want HTTPS, add TLS configuration:
```yaml
ingress:
  tls:
  - hosts:
    - teamcity.local
    secretName: teamcity-tls
```

### 7. **TeamCity Configuration Issues**

**Public URL Mismatch:**
Make sure the `server.publicUrl` in values.yaml matches your ingress host:
```yaml
server:
  publicUrl: http://teamcity.local
```

## Quick Fix Commands

```bash
# Reinstall the chart with updated values
helm upgrade --install teamcity . -f values.yaml

# Check all resources
kubectl get all -l app=teamcity-teamcity

# Test the service
kubectl port-forward svc/teamcity-teamcity-server 8111:8111
```

## Expected Behavior

After fixing the issues:
1. Ingress should be created and show as "Ready"
2. You should be able to access TeamCity at `http://teamcity.local`
3. TeamCity should start up and show the setup wizard
4. The forwarded headers should work correctly 
