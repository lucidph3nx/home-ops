# home-ops
Definitions of my home infrastructure

## Cluster Secrets
Flux is expecting a `.cluster-secrets.yaml` to be applied in order to subsitute values.
This file is in the .gitignore so that it doesnt end up in a public repo oneday. it just needs to be structured like so:
```
apiVersion: v1
kind: Secret
metadata:
  name: cluster-secrets
  namespace: flux-system
type: Opaque
stringData:
  SECRET_EMAIL: XXX
  SECRET_PUBLIC_DOMAIN: XXX
```