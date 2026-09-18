# gitlab-runner secrets

`sealed-secret-cache.yaml` (MinIO credentials for the distributed cache) is
already here; the `gitlab-runner-cache` bucket is created by the MinIO bucket job
in the `gitlab` application.

What is missing is the runner authentication token, which only exists once a
runner has been created in a running GitLab (registration tokens are gone since
GitLab 18).

1. In GitLab: Admin area > CI/CD > Runners > New instance runner. Tick
   "Run untagged jobs", create it, copy the `glrt-...` token.

2. Seal it. Both keys are required: the chart projects `runner-token` **and**
   `runner-registration-token` from this secret, and a missing key fails the
   volume mount. The registration one stays empty.

```bash
kubectl --context kubernetes-admin@cluster.local \
  create secret generic gitlab-runner-token -n gitlab-runner \
  --dry-run=client -o yaml \
  --from-literal=runner-token='glrt-xxxxxxxx' \
  --from-literal=runner-registration-token='' \
| kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets \
    --format yaml --scope strict > sealed-secret-runner-token.yaml
```

3. Commit and push. ArgoCD syncs the secret, the pod mounts it and the runner
   registers itself:

```bash
kubectl --context kubernetes-admin@cluster.local -n gitlab-runner logs deploy/gitlab-runner --tail=20
```
