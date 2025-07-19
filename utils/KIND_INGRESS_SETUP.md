# Kind Cluster Ingress Setup

## The Problem
You're using a Kind cluster, and the ingress controller is not accessible from your host machine because Kind doesn't automatically expose NodePorts to the host.

## Solution 1: Port Forward the Ingress Controller

```bash
# Port forward the ingress controller service
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

# Now you can access TeamCity at:
# http://teamcity.local:8080
```

## Solution 2: Use Kind's Extra Ports (Recommended)

Create a Kind cluster configuration that exposes the ingress ports:

```yaml
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
```

Then recreate your cluster:

```bash
# Delete existing cluster
kind delete cluster

# Create new cluster with port mapping
kind create cluster --config kind-config.yaml

# Reinstall ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

# Reinstall TeamCity
helm upgrade --install teamcity . -f values.yaml
```

## Solution 3: Use kubectl port-forward (Quick Fix)

```bash
# Port forward the TeamCity service directly
kubectl port-forward svc/teamcity-teamcity-server 8111:8111

# Access TeamCity at http://localhost:8111
```

## Solution 4: Use MetalLB (For LoadBalancer)

If you want to use LoadBalancer type:

```bash
# Install MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

# Create IP address pool
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 172.18.255.200-172.18.255.250
EOF

# Create L2Advertisement
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF
```

## Current Status
Your TeamCity is working fine - the issue is just accessing it through the ingress from your host machine.

## Quick Test
Try this to verify everything is working:

```bash
# Port forward the ingress controller
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

# In another terminal, test the ingress
curl -I http://teamcity.local:8080
```

You should get a 401 response (which is expected for TeamCity without authentication). 
