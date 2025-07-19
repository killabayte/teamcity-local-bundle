#!/bin/bash

# TeamCity Helm Chart Deployment Script
# This script deploys TeamCity to your Kubernetes cluster

set -e

echo "Deploying TeamCity to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "ERROR: kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if helm is available
if ! command -v helm &> /dev/null; then
    echo "ERROR: helm is not installed. Please install helm first."
    exit 1
fi

# Check if we're connected to a cluster
if ! kubectl cluster-info &> /dev/null; then
    echo "ERROR: Not connected to a Kubernetes cluster. Please configure kubectl first."
    exit 1
fi

echo "SUCCESS: Kubernetes cluster connection verified"

# Check if ingress controller is installed
if ! kubectl get pods -n ingress-nginx &> /dev/null; then
    echo "WARNING: NGINX Ingress Controller not found. Installing..."
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
    
    echo "Waiting for ingress controller to be ready..."
    kubectl wait --namespace ingress-nginx \
      --for=condition=ready pod \
      --selector=app.kubernetes.io/component=controller \
      --timeout=120s
else
    echo "SUCCESS: NGINX Ingress Controller already installed"
fi

# Add teamcity.local to /etc/hosts if not present
if ! grep -q "teamcity.local" /etc/hosts; then
    echo "Adding teamcity.local to /etc/hosts..."
    echo "127.0.0.1 teamcity.local" | sudo tee -a /etc/hosts
else
    echo "SUCCESS: teamcity.local already in /etc/hosts"
fi

# Deploy TeamCity
echo "Installing TeamCity Helm chart..."
helm upgrade --install teamcity ../ -f ../values.yaml

echo "Waiting for TeamCity to be ready..."
kubectl wait --for=condition=ready pod -l app=teamcity-teamcity,component=server --timeout=300s

echo "SUCCESS: TeamCity deployment completed!"

# Show status
echo ""
echo "Deployment Status:"
kubectl get pods -l app=teamcity-teamcity

echo ""
echo "Access TeamCity:"
echo "   URL: http://teamcity.local:8080"
echo "   (Use port forwarding for Kind clusters)"
echo ""
echo "Port Forward Command:"
echo "   kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80"
echo ""
echo "Next Steps:"
echo "   1. Start port forwarding (see command above)"
echo "   2. Open http://teamcity.local:8080 in your browser"
echo "   3. Complete TeamCity setup"
echo "   4. Authorize the 2 agents in the Agents page"
echo ""
echo "TeamCity is ready to use!" 
