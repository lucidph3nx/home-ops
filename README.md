# home-ops

## Project Purpose

The purpose of this project is to define and manage the infrastructure of my home environment. This includes various applications and services running on a Kubernetes cluster, which is managed by Flux. The project aims to provide a reliable and scalable home infrastructure setup.

## Features

- **Kubernetes Cluster**: The core of the infrastructure is a Kubernetes cluster, which provides a scalable and resilient environment for running applications.
- **Flux**: Flux is used for continuous deployment, ensuring that the cluster state is always in sync with the configuration defined in this repository.
- **Ansible**: Ansible is used for provisioning and managing the Kubernetes nodes.
- **SOPS**: SOPS is used for managing secrets, ensuring that sensitive information is encrypted and securely stored.
- **Taskfile**: Taskfile is used for automating various tasks, such as preparing and installing the cluster, encrypting and decrypting files, and more.

## Installation Steps

1. **Prepare the Kubernetes Nodes**:
    ```bash
    task ansible:prepare
    ```

2. **Install Kubernetes on the Nodes**:
    ```bash
    task ansible:install
    ```

3. **Bootstrap the Cluster**:
    Follow the steps detailed in the `/kubernetes/cluster0/bootstrap/README.md`.

## Troubleshooting

If anything goes wrong during the installation process, you can use the following command to uninstall Kubernetes and start again from the installation step:
```bash
task ansible:nuke
```

## Usage

Once the cluster is set up, you can use Flux to manage the state of the cluster. Any changes made to the configuration in this repository will be automatically applied to the cluster by Flux.

## Components Overview

- **Kubernetes**: The core platform for running containerized applications.
- **Flux**: Manages the continuous deployment of applications to the Kubernetes cluster.
- **Ansible**: Automates the provisioning and management of the Kubernetes nodes.
- **SOPS**: Manages the encryption and decryption of secrets.
- **Taskfile**: Automates various tasks related to the management of the cluster.

## Additional Information

For more detailed information about each component and how to use them, refer to the respective documentation in the project directories.
