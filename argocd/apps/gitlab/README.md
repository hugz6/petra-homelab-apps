# GitLab

Cloud-native GitLab (chart `gitlab` 10.3.2 / GitLab 19.3.2) on `gitlab.beutra.fr`,
container registry on `registry.beutra.fr`.

Chart 10 removed the bundled PostgreSQL, Redis and MinIO, so this app ships its
own datastores:

| Component | Where | Notes |
|---|---|---|
| PostgreSQL | `postgres/cnpg-cluster.yaml` | CNPG, 3 instances, **PG 17 pinned** (GitLab 19 supports 17 only) |
| Redis | `datastores/valkey.yaml` | Valkey 8, single node, 8Gi |
| Object storage | `datastores/minio.yaml` | single-node MinIO, 100Gi, buckets created by a sync-hook Job |

## First boot

1. Push; ArgoCD syncs datastores (wave -2), buckets (wave -1), then the chart.
   The `migrations` job waits for Postgres, so the first sync takes a while.
2. Get the generated root password:

```bash
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

## SSO

Authentik OIDC ("Sign in with Authentik"), provider defined in
`argocd/infra/authentik/blueprints/applications.yaml`. Local root login stays
available. After changing blueprints, restart `deploy/authentik-worker` and
`deploy/authentik-server` so they are re-applied.

## Known limits

- **No git over SSH**: the frp tunnel only forwards 80/443, so `gitlab-shell` is
  disabled. Clone over HTTPS.
- **No outgoing email**: SMTP is not configured (`global.smtp`), so password
  resets and notifications do not leave the cluster.
- **No scheduled backups**: `gitlab.toolbox.backups.cron.enabled` is off. The
  s3cmd credentials are in place, so enabling it is a values change; backups land
  in the `gitlab-backups` bucket on the same MinIO as the data it backs up.
- KAS (agent server), Pages and Zoekt are disabled.
