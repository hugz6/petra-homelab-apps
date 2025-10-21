# 🏠 Petra's Homelab

> A student's journey into Kubernetes infrastructure and GitOps practices

## 👋 Introduction

Welcome to my personal homelab! This repository serves as my playground for exploring K8s, DevOps, GitOps, and cloud-native technologies.
This is a learning project, so expect experimentation, occasional dumb things, and continuous improvement!
Feel free to explore, learn from it, or reach out if you have suggestions.

## 🚀 Overview

This repository contains the complete Infrastructure as Code (IaC) setup for my homelab.
It follows GitOps principles with ArgoCD managing both infrastructure components and applications,
while GitHub Actions automates the build and packaging of Helm charts.

### 🛠️ Tech Stack

- **Infrastructure Provisioning**: Terraform
- **Kubernetes Deployment**: Kubespray
- **GitOps**: ArgoCD (App of Apps pattern)
- **CI/CD**: GitHub Actions
- **Ingress**: NGINX Ingress Controller
- **Load Balancing**: MetalLB
- **Storage**: Longhorn
- **Secrets Management**: Sealed Secrets
- **Package Management**: Helm
- **Virtualisation**: Proxmox 9

## 🚢 Hardware

This Homelab runs on:

- 2 \* GMKtec M5 plus (1TO SSD NVME, 32 Go RAM) Mini pcs
- 1 \* tp-link TL-SG605E Switch

## 📁 Repository Structure

```
.
├── terraform/           # Infrastructure provisioning
├── kubespray/          # Kubernetes cluster deployment
├── kubernetes/         # Kubernetes manifests
│   ├── bootstrap/      # ArgoCD App of Apps
│   ├── infra/         # Infrastructure components
│   └── apps/          # Application deployments
└── helm-charts/       # Custom Helm charts
```

## 🔧 Infrastructure Components

### Core Infrastructure (`kubernetes/infra/`)

- **🔄 ArgoCD**: GitOps continuous delivery tool with a beautiful UI
- **⚖️ MetalLB**: Bare-metal load balancer for on-premises Kubernetes
- **🌐 NGINX Ingress**: Ingress controller for HTTP/HTTPS routing
- **💾 Longhorn**: Distributed block storage system with replication
- **🔐 Sealed Secrets**: Encrypted secrets management (no more plain-text secrets!)
- **👥 RBAC**: Role-based access control with admin and developer roles

### Applications (`kubernetes/apps/`)

- **🚪 Garlicdoor**: Custom Web startpage/portal for my homelab deployed via Helm

## 🔄 GitOps Workflow

This homelab uses ArgoCD's **App of Apps** pattern for managing everything declaratively:

1. **Bootstrap Apps** (`bootstrap/`) define two parent applications:
   - `infra-app-of-apps.yaml`: Manages all infrastructure components
   - `apps-app-of-apps.yaml`: Manages all user applications

2. **Infrastructure Apps** (`infra/`) are automatically synced and deployed by ArgoCD
3. **Application Apps** (`apps/`) are deployed with custom values and ingress configurations

## 📦 Custom Helm Charts

### Garlicdoor Chart

Located in `helm-charts/garlicdoor/`, this custom chart includes:

- Deployment with configurable replicas
- Service for internal communication
- ConfigMap for application configuration
- ServiceAccount for RBAC
- Horizontal Pod Autoscaler (HPA)

### 🤖 Automated Chart Building

GitHub Actions automatically builds and packages Helm charts on every push:

- 📦 Charts are built and tested
- ✅ Version validation
- 🚀 Automated packaging for deployment

This ensures that all charts are properly validated before ArgoCD deploys them to the cluster.

## 🌐 Network Configuration

MetalLB is configured with:

- IP Address Pool for LoadBalancer services
- L2 Advertisement mode for network integration

All services get real IP addresses on my network, making the homelab feel like a production cluster! 🎯

## 💾 Storage

Longhorn provides:

- Distributed replicated block storage across nodes
- Volume snapshots and backups
- Web UI for storage management
- High availability for stateful applications
