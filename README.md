# home-ops
Definitions of my home infrastructure

Mostly just Kubernetes, managed by Flux in the kubernetes/ directory

# Install Steps
```bash
task ansible:prepare
task ansible:install
# follow steps detailed in the /kubernetes/cluster0/bootstrap/README.md
```
if anything goes wrong in this process, use `task anisble:nuke` and start again from the `anisble:install` step
