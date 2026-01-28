# Petra Homelab

Welcome to the heart of my homelab infrastructure! This repository serves as the central hub for **ArgoCD Infrastructure as Code (IaC)** and houses my **custom Helm Charts**.

## Repository Structure

The repository is organized into two main sections:

### 1. `argocd/`
Contains the declarative definitions for ArgoCD applications and projects.

- **`apps/`**: Application definitions for services.
- **`bootstrap/`**: Initial bootstrap manifests to kickstart the cluster.
- **`infra/`**: Application definitions for infrastructure components.

### 2. `helm-charts/`
Custom Helm charts developed specifically for this environment.

- **`frp/`**: Chart for the Fast Reverse Proxy.
- **`garlicdoor/`**: Custom application chart.

## Usage

To bootstrap the cluster, apply the bootstrap configuration:

```bash
kubectl apply -f argocd/bootstrap/bootstrap-infra.yaml
kubectl apply -f argocd/bootstrap/bootstrap-apps.yaml
```