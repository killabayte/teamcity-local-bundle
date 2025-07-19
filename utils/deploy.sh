#!/bin/bash

# TeamCity Helm Chart Deployment Script
# Usage: ./deploy.sh [kind|ingress|teamcity|all]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    
    if ! command -v helm &> /dev/null; then
        print_error "helm is not installed. Please install helm first."
        exit 1
    fi
    
    print_status "Prerequisites check passed"
}

# Function to setup Kind cluster
setup_kind() {
    print_step "Setting up Kind cluster..."
    
    if ! command -v kind &> /dev/null; then
        print_error "kind is not installed. Please install kind first."
        print_warning "Install with: brew install kind"
        exit 1
    fi
    
    # Check if we have a Kind cluster
    if kind get clusters | grep -q "kansas"; then
        print_warning "Kind cluster already exists."
        read -p "Do you want to delete the existing cluster and create a new one? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Deleting existing Kind cluster..."
            kind delete cluster --name emerald-city
        else
            print_status "Using existing Kind cluster"
            return
        fi
    fi
    
    print_status "Creating new Kind cluster with 2 worker nodes and port 8080 exposed..."
    kind create cluster --name kansas --config kind-startup-config.yaml
    
    print_status "Kind cluster created successfully!"
    echo
    print_status "Cluster Information:"
    kind get clusters
    kubectl cluster-info
    echo
    print_status "Node Information:"
    kubectl get nodes
    echo
}

# Function to setup Ingress Controller
setup_ingress() {
    print_step "Setting up NGINX Ingress Controller..."
    
    # Check if we're connected to a cluster
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Not connected to a Kubernetes cluster."
        print_warning "Please run './deploy.sh kind' first to create a cluster."
        exit 1
    fi
    
    # Check if ingress controller is installed
    if ! kubectl get pods -n ingress-nginx &> /dev/null; then
        print_status "Installing NGINX Ingress Controller..."
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
        
        print_status "Waiting for ingress controller to be ready..."
        kubectl wait --namespace ingress-nginx \
          --for=condition=ready pod \
          --selector=app.kubernetes.io/component=controller \
          --timeout=120s
    else
        print_status "NGINX Ingress Controller already installed"
    fi
    
    print_status "Ingress controller setup completed!"
}

# Function to setup TeamCity
setup_teamcity() {
    print_step "Setting up TeamCity..."
    
    # Check if we're connected to a cluster
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Not connected to a Kubernetes cluster."
        print_warning "Please run './deploy.sh kind' first to create a cluster."
        exit 1
    fi
    
    # Add teamcity.local to /etc/hosts if not present
    if ! grep -q "teamcity.local" /etc/hosts; then
        print_status "Adding teamcity.local to /etc/hosts..."
        echo "127.0.0.1 teamcity.local" | sudo tee -a /etc/hosts
    else
        print_status "teamcity.local already in /etc/hosts"
    fi
    
    print_status "Installing TeamCity Helm chart..."
    helm upgrade --install teamcity ../ -f ../values.yaml
    
    print_status "Waiting for TeamCity to be ready..."
    kubectl wait --for=condition=ready pod -l app=teamcity-teamcity,component=server --timeout=300s
    
    print_status "TeamCity deployment completed!"
    
    # Show status
    echo
    print_status "Deployment Status:"
    kubectl get pods -l app=teamcity-teamcity
    
    echo
    print_status "Access TeamCity:"
    print_status "   URL: http://teamcity.local:8080"
    
    # Check if we're using Kind with port mapping
    if command -v kind &> /dev/null && kind get clusters | grep -q "kansas"; then
        print_status "Using Kind cluster with port 8080 exposed!"
        print_status "   No port forwarding needed - access directly at http://teamcity.local:8080"
    else
        print_warning "Port Forward Command (if needed):"
        print_status "   kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80"
    fi
    
    echo
    print_step "Next Steps:"
    print_status "   1. Open http://teamcity.local:8080 in your browser"
    print_status "   2. Complete TeamCity setup"
    print_status "   3. Authorize the 2 agents in the Agents page"
    echo
    print_status "TeamCity is ready to use!"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  kind      - Create Kind cluster with 2 nodes and port 8080 exposed"
    echo "  ingress   - Install NGINX Ingress Controller"
    echo "  teamcity  - Deploy TeamCity to the cluster"
    echo "  all       - Run all steps (kind + ingress + teamcity)"
    echo "  help      - Show this help message"
    echo
    echo "Examples:"
    echo "  $0 kind           # Only create Kind cluster"
    echo "  $0 ingress        # Only install ingress controller"
    echo "  $0 teamcity       # Only deploy TeamCity"
    echo "  $0 all            # Complete setup"
    echo
}

# Function to run all steps
run_all() {
    print_step "Running complete TeamCity setup..."
    check_prerequisites
    setup_kind
    setup_ingress
    setup_teamcity
    print_status "Complete setup finished!"
}

# Main script logic
case "${1:-}" in
    "kind")
        check_prerequisites
        setup_kind
        ;;
    "ingress")
        check_prerequisites
        setup_ingress
        ;;
    "teamcity")
        check_prerequisites
        setup_teamcity
        ;;
    "all")
        run_all
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    "")
        echo "TeamCity Deployment Script"
        echo "========================="
        echo
        show_usage
        echo "Please choose what you want to install:"
        echo "1) kind - Create Kind cluster"
        echo "2) ingress - Install NGINX Ingress Controller"
        echo "3) teamcity - Deploy TeamCity"
        echo "4) all - Complete setup"
        echo "5) help - Show help"
        echo
        read -p "Enter your choice (1-5): " choice
        case $choice in
            1) check_prerequisites; setup_kind ;;
            2) check_prerequisites; setup_ingress ;;
            3) check_prerequisites; setup_teamcity ;;
            4) run_all ;;
            5) show_usage ;;
            *) print_error "Invalid choice"; exit 1 ;;
        esac
        ;;
    *)
        print_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
esac 
