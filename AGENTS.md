# Agent Information

This document contains important context for AI agents working with this repository.

## Repository Overview

This is a GitOps repository managing a Kubernetes homelab cluster using Flux CD. All cluster configuration is stored as code, and Flux automatically reconciles the cluster state with the Git repository.

### Key Technologies

- **Flux CD**: GitOps toolkit that continuously reconciles cluster state with Git
- **Kubernetes**: Running on a k3s cluster (cluster name: `cluster0`)
- **Renovate**: Automated dependency updates via GitHub PRs
- **Helm**: Package manager for Kubernetes applications
- **Kustomize**: Template-free way to customize Kubernetes resources

## Repository Structure

```
kubernetes/cluster0/
├── apps/               # Application deployments organized by namespace
├── bootstrap/         # Initial cluster bootstrap configuration
├── flux/              # Flux CD configuration
│   ├── config/        # Cluster-wide settings
│   ├── repositories/  # Helm and Git repositories
│   └── vars/          # Cluster variables and secrets
```

## Flux CD Patterns

### HelmRelease Resources

Applications are deployed using Flux `HelmRelease` resources. After merging PRs:
1. Flux detects the Git change (within ~1 minute by default)
2. Flux reconciles the HelmRelease
3. Helm upgrades the release in the cluster
4. Kubernetes rolls out the new deployment/statefulset

**Force immediate reconciliation:**
```bash
flux reconcile source git home-ops-cluster0
```

**Checking HelmRelease status:**
```bash
# View all HelmReleases
kubectl get helmreleases -A

# Check specific release
kubectl get helmrelease <name> -n <namespace> -o yaml

# Get the chart version
kubectl get helmrelease <name> -n <namespace> -o jsonpath='{.spec.chart.spec.version}'
```

### Kustomization Resources

Flux uses `Kustomization` resources (not to be confused with Kustomize's `kustomization.yaml`) to apply sets of manifests. These are defined in `ks.yaml` files throughout the repository.

## Resource Naming Conventions

⚠️ **CRITICAL**: Resource names in Kubernetes often don't match application names. Always verify actual resource names before running commands.

### Common Patterns in This Repository

| Application | Namespace | Resource Type | Actual Resource Name |
|------------|-----------|---------------|---------------------|
| prometheus-operator | monitoring | Deployment | `prometheus-kube-prometheus-operator` |
| prometheus | monitoring | StatefulSet | `prometheus-prometheus-kube-prometheus` |
| grafana | monitoring | Deployment | `grafana` |
| cert-manager | cert-manager | Deployment | `cert-manager` |
| trust-manager | cert-manager | Deployment | `trust-manager` |
| cloudnative-pg | databases | Deployment | `cloudnative-pg` |
| home-assistant | home | Deployment | `home-assistant` |
| intel-gpu-plugin | kube-system | DaemonSet | `intel-gpu-plugin-intel-gpu-plugin` |
| valkey (authelia) | auth | StatefulSet | `valkey` |
| valkey (searxng) | home | StatefulSet | `searxng-valkey` |
| valkey (blocky) | networking | StatefulSet | `blocky-valkey` |
| reloader | kube-system | Deployment | `reloader` |

### Safe Approach for Finding Resources

Always use this pattern to avoid mistakes:

```bash
# 1. Find the HelmRelease
kubectl get helmreleases -A | grep <app-name>

# 2. List resources in that namespace
kubectl -n <namespace> get all | grep <app-name>

# 3. Check specific resource type
kubectl -n <namespace> get deployments,statefulsets,daemonsets

# 4. Then check rollout with exact names
kubectl -n <namespace> rollout status deployment/<exact-name>
```

## Multiple Instances

Some applications have multiple instances deployed:
- **valkey**: 3 instances (auth, home/searxng, networking/blocky)
- **blocky**: 2 instances (primary, secondary)
- **postgres clusters**: Multiple managed by cloudnative-pg operator

Always check all instances when reviewing updates.

## Working with GitHub CLI

This repository uses `gh` for PR management:

```bash
# List PRs
gh pr list --state open --author "renovate[bot]"

# View PR details
gh pr view <number> --json title,body,files

# Merge PR (without auto-merge as branch protection isn't configured)
gh pr merge <number> --squash

# View issue
gh issue view <number>

# Edit issue (for Renovate triggers)
gh issue edit <number>
```

## Renovate Configuration

- **Dependency Dashboard**: Issue #1 tracks all detected dependencies
- **Rate Limited PRs**: Major updates are rate-limited and must be manually triggered
- **Auto-merge**: Disabled - all PRs require manual review
- **Schedule**: Runs weekly on weekends (Pacific/Auckland timezone)
- **Labels**: PRs are labeled with `dep/patch`, `dep/minor`, `dep/major`, and package type

### Renovate Special Checkboxes

Issue #1 contains checkboxes that trigger Renovate actions:
- Creating all rate-limited PRs at once
- Forcing Renovate to run again

## Update Strategy

### Patch Updates (0.0.x)
- Generally safe, contain bug fixes only
- Review release notes briefly
- Can be merged in batches

### Minor Updates (0.x.0)
- New features, backward compatible
- Review release notes for new features
- Check configuration compatibility

### Major Updates (x.0.0)
- **Potential breaking changes**
- Must review upgrade guides
- Check for deprecated configuration options
- Test carefully in monitoring stack

### Security Updates
Priority updates that should be merged quickly:
- Any CVE fixes
- cert-manager / trust-manager (TLS infrastructure)
- authelia (authentication)
- Prometheus operator (monitoring)
- Cilium (networking)

## Init Containers

Some applications use init containers that must complete before the main container starts:
- **home-assistant**: Uses `git-sync` init container to pull config from Git
- Check pod status carefully - `Init:0/1` is normal during startup

## Best Practices

1. **Never assume resource names** - Always verify with `kubectl get`
2. **Check all namespaces** - Some apps have multiple instances
3. **Read existing configs** - Understanding current setup helps assess safety
4. **Merge sequentially** - Multiple PRs merged in parallel cause conflicts
5. **Wait for Flux reconciliation** - Allow 1-2 minutes after merge for Flux to act, or force with `flux reconcile source git home-ops-cluster0`
6. **Verify HelmRelease status** - Don't just check pods, check the HelmRelease
7. **Check init containers** - Some pods take longer to start due to init steps
8. **Review major updates carefully** - Check upstream docs for breaking changes

## Cluster Timezone

The cluster is configured for **Pacific/Auckland** timezone. Consider this when reviewing scheduled jobs and maintenance windows.
