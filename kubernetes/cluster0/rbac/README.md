# RBAC Setup Instructions

## Overview

This cluster now has a `agents-readonly` ServiceAccount with read-only cluster access for AI agents.

## Files Created

- `kubernetes/cluster0/rbac/roles/agents-readonly.yaml` - ServiceAccount, ClusterRole, and ClusterRoleBinding
- `kubernetes/cluster0/rbac/kustomization.yaml` - Kustomize config
- `kubernetes/cluster0/flux/rbac.yaml` - Flux Kustomization
- `kubernetes/cluster0/flux/config/kustomization.yaml` - Updated to include rbac.yaml

## Generating the Kubeconfig

After merging these changes and allowing Flux to reconcile (or force with `flux reconcile source git home-ops-cluster0`), generate the kubeconfig:

### 1. Generate a long-lived token (10 years)

```bash
kubectl -n kube-system create token agents-readonly --duration=87600h
```

### 2. Build the kubeconfig file

Create a new file `agents-readonly-kubeconfig.yaml`:

```yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: <COPY FROM YOUR ADMIN KUBECONFIG>
    server: <COPY FROM YOUR ADMIN KUBECONFIG>
  name: cluster0
contexts:
- context:
    cluster: cluster0
    user: agents-readonly
  name: agents-readonly@cluster0
current-context: agents-readonly@cluster0
users:
- name: agents-readonly
  user:
    token: <TOKEN FROM STEP 1>
```

**To extract values from your admin kubeconfig:**

```bash
# Get server URL
kubectl config view --minify --raw -o jsonpath='{.clusters[0].cluster.server}'

# Get CA certificate
kubectl config view --minify --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}'
```

### 3. Test the kubeconfig

```bash
# Test read access (should work)
KUBECONFIG=agents-readonly-kubeconfig.yaml kubectl get pods -A

# Test write access (should fail with forbidden error)
KUBECONFIG=agents-readonly-kubeconfig.yaml kubectl delete pod test-pod
```

### 4. Encrypt and store in NixOS repo

Use the same encryption workflow you use for your admin kubeconfig (sops-nix or agenix).

## Permissions

The `agents-readonly` ServiceAccount has:
- ✅ `get`, `list`, `watch` on all resources
- ✅ `get` on non-resource URLs (healthz, metrics, etc.)
- ❌ No `create`, `update`, `patch`, `delete`, `deletecollection`

## Token Expiration

The token expires after 10 years. To regenerate:

```bash
# Generate new token
kubectl -n kube-system create token agents-readonly --duration=87600h

# Update the token in your kubeconfig
# Re-encrypt and update in NixOS repo
```

## Audit Trail

All API calls made with this kubeconfig will appear in Kubernetes audit logs as:
```
user: system:serviceaccount:kube-system:agents-readonly
```
