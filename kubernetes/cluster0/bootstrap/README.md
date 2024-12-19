# Bootstrap

## Purpose

The purpose of this bootstrap process is to set up and configure the initial state of the Kubernetes cluster using Flux. This includes installing Flux, applying cluster configurations, and kicking off the Flux process to manage the cluster state.

## Components Overview

- **Flux**: Flux is a set of continuous and progressive delivery solutions for Kubernetes that are open and extensible. It ensures that the cluster state is always in sync with the configuration defined in this repository.
- **SOPS**: SOPS is used for managing secrets, ensuring that sensitive information is encrypted and securely stored.
- **Kustomize**: Kustomize is used for customizing Kubernetes resource configurations.

## Bootstrap Steps

### Install Flux

```sh
kubectl apply --server-side --kustomize ./kubernetes/cluster0/bootstrap/flux
```

### Apply Cluster Configuration

_These cannot be applied with `kubectl` in the regular fashion due to being encrypted with sops_

```sh
sops --decrypt kubernetes/cluster0/bootstrap/flux/age-key.sops.yaml | kubectl apply -f -
sops --decrypt kubernetes/cluster0/bootstrap/flux/github-deploy-key.sops.yaml | kubectl apply -f -
sops --decrypt kubernetes/cluster0/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
kubectl apply -f kubernetes/cluster0/flux/vars/cluster-settings.yaml
```

### Kick off Flux applying this repository

```sh
kubectl apply --server-side --kustomize ./kubernetes/cluster0/flux/config
```

## Troubleshooting

If anything goes wrong during the bootstrap process, you can use the following command to uninstall Kubernetes and start again from the installation step:
```bash
task ansible:nuke
```

## Additional Information

For more detailed information about each component and how to use them, refer to the respective documentation in the project directories.
