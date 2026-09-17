# gitlab-runner secrets

Two sealed secrets are needed here; both depend on a running GitLab, so they are
created after the `gitlab` application is healthy.

1. Create a runner in GitLab (Admin area > CI/CD > Runners > New instance runner),
   copy the authentication token (`glrt-...`), then:

```bash
kubectl create secret generic gitlab-runner-token -n gitlab-runner \
  --dry-run=client -o yaml \
  --from-literal=runner-token='glrt-xxxxxxxx' \
| kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets \
    --format yaml > sealed-secret-runner-token.yaml
```

2. Distributed cache credentials (same MinIO root credentials as GitLab; create
   the `gitlab-runner-cache` bucket first with `mc mb`):

```bash
kubectl create secret generic gitlab-runner-cache-credentials -n gitlab-runner \
  --dry-run=client -o yaml \
  --from-literal=accesskey="$(kubectl get secret gitlab-minio-credentials -n gitlab -o jsonpath='{.data.accesskey}' | base64 -d)" \
  --from-literal=secretkey="$(kubectl get secret gitlab-minio-credentials -n gitlab -o jsonpath='{.data.secretkey}' | base64 -d)" \
| kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets \
    --format yaml > sealed-secret-cache.yaml
```

Commit both files, push, and the runner registers itself.
