# FRP Client Helm Chart

This Helm chart deploys a FRP (Fast Reverse Proxy) client on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A running FRP server

## Installation

### Basic Installation

```bash
helm install my-frp-client . \
  --set secret.enabled=true \
  --set secret.token="your-frp-token" \
  --set frpc.serverAddr="frps.example.com" \
  --set frpc.serverPort=7000
```

### Installation with Custom Values

Create a `values-prod.yaml` file:

```yaml
secret:
  enabled: true
  token: "your-secure-token-here"

frpc:
  serverAddr: "frps.yourdomain.com"
  serverPort: 7000
  
  log:
    level: "info"
    maxDays: 7
  
  proxies:
    - name: "my-web-service"
      type: "http"
      localIP: "my-service.default.svc.cluster.local"
      localPort: 80
      customDomains:
        - "myapp.example.com"
    
    - name: "my-ssh"
      type: "tcp"
      localIP: "my-ssh-service.default.svc.cluster.local"
      localPort: 22
      remotePort: 6000
```

Then install:

```bash
helm install my-frp-client . -f values-prod.yaml
```

## Configuration

### Key Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas (should be 1) | `1` |
| `image.repository` | FRP image repository | `fatedier/frp` |
| `image.tag` | FRP image tag | `v0.61.0` |
| `secret.enabled` | Enable secret for token | `false` |
| `secret.token` | FRP authentication token | `""` |
| `frpc.serverAddr` | FRP server address | `frps.example.com` |
| `frpc.serverPort` | FRP server port | `7000` |
| `frpc.auth.method` | Authentication method | `token` |
| `frpc.log.level` | Log level | `info` |
| `resources.limits.cpu` | CPU limit | `200m` |
| `resources.limits.memory` | Memory limit | `128Mi` |

### Proxy Types

The chart supports all FRP proxy types:

- **HTTP**: Web services with custom domains
- **HTTPS**: Secure web services
- **TCP**: Generic TCP services
- **UDP**: Generic UDP services
- **STCP**: Secret TCP (requires secret key)

## Security

This chart implements production-ready security practices:

- ✅ Non-root user (UID 1000)
- ✅ Read-only root filesystem
- ✅ Dropped all capabilities
- ✅ No privilege escalation
- ✅ Seccomp profile enabled
- ✅ Service account token auto-mount disabled

## Uninstallation

```bash
helm uninstall my-frp-client
```

## Support

For FRP documentation, visit: https://github.com/fatedier/frp

