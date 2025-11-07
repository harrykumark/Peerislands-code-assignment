#!/bin/bash
set -e

# Create namespace for monitoring
kubectl apply -f k8s/namespace.yaml

# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus + Grafana using Helm
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f k8s/prometheus-grafana-values.yaml

# Wait until Grafana is deployed
echo "⏳ Waiting for Grafana deployment to be ready..."
kubectl rollout status deployment/monitoring-grafana -n monitoring

# Display access information
echo "✅ Monitoring stack deployed successfully!"
kubectl get svc -n monitoring | grep grafana
