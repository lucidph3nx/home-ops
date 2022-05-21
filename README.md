# home-ops
Definitions of my home infrastructure

### ⚠️ pre-commit

It is advisable to install [pre-commit](https://pre-commit.com/) and the pre-commit hooks that come with this repository.
[sops-pre-commit](https://github.com/k8s-at-home/sops-pre-commit) and [gitleaks](https://github.com/zricethezav/gitleaks) will check to make sure you are not by accident committing un-encrypted secrets.

1. Enable Pre-Commit

    ```sh
    task precommit:init
    ```

2. Update Pre-Commit, though it will occasionally make mistakes, so verify its results.

    ```sh
    task precommit:update
    ```

