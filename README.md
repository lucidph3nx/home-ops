# home-ops

## Current state 2025-08-06
This repository was boostrapped using an older version of the [onedr0p/cluster-template](https://github.com/onedr0p/cluster-template), back when it was using general purpose operating systems and k3s.
If i were to start over, I would use Talos. I may yet migrate to using it, but it is difficult with a small existing cluster as they are not interoperable.
As far as the other components go, I am very happy, Flux, Cilium and Longhorn are all great tools.
I've removed all of the ansible, taskfiles etc as they are no longer functional and I wouldn't recommend using them.

## Project Purpose

The purpose of this project is to define and manage the infrastructure of my home environment. This includes various applications and services running on a Kubernetes cluster, which is managed by Flux. The project aims to provide a reliable and scalable home infrastructure setup.

## Features

- **Kubernetes Cluster**: The core of the infrastructure is a Kubernetes cluster, which provides a scalable and resilient environment for running applications.
- **Flux**: Flux is used for continuous deployment, ensuring that the cluster state is always in sync with the configuration defined in this repository.

## Components

- **Kubernetes**: The core platform for running containerized applications.
- **Flux**: Manages the continuous deployment of applications to the Kubernetes cluster.
- **Longhorn**: Provides persistent storage for the Kubernetes cluster.
- **SOPS**: Manages the encryption and decryption of secrets.

