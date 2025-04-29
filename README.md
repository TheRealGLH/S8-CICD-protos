# S8 CI/CD Protos
This repository contains the Infrastructure as Code files for my graduation project. 

The C++ template project with its own Dockerfile used in the Jenkins pipeline should have its own repository as part of the portfolio, and for modularity's sake has not been included in this repo.
## Project structure


The contents of this repository are split between the following folders, each containing their own README file as well:
- ``baseline/``: The initial attempt at trying to copy the existing structure to a local instance, as far as I could gleam from the context clues given.
- ``opentf-helm-vcs/``: The Terraform/ OpenTofu project for managing VCS tools and related services, like Jenkins and GitLab.
- ``opentf-jenkins/``: The Terraform/ OpenTofu project that Jenkins is meant to deploy as part of the CI/CD build process.
- ``redhat-docker/``: Docker image and compose files for the C++ build environment with a Red Hat Linux UBI (universal base image) as its base.

## Running project files

The following tools and versions were used:
- Docker version 27.5.1, build 9f9e405
- KubeCTL Client Version: v1.32.3, Kustomize Version: v5.5.0
- k3d version v5.8.2
- OpenTofu version v1.9.0
- Helm ``version.BuildInfo{Version:"v3.17.2", GitCommit:"cc0bbbd6d6276b83880042c1ecb34087e84d41eb", GitTreeState:"clean", GoVersion:"go1.23.7"}``

## Useful inspect commands
Commands for managing and deploying build tools can be found in the individual folders' ``README.md`` files.
### Kubernetes
Watch all k8s delpoyments, pods and persistent volume claims
```sh
watch --no-title kubectl get deployment,pod,pvc
```
Watch all k8s delpoyments, pods and persistent volume claims
```sh
watch --no-title kubectl get deployment,pod,pvc -n devops-tools
```
Watch all k8s delpoyments, pods and persistent volume claims in *every* namespace.
```sh
watch --no-title kubectl get deployment,pod,pvc --all-namespaces
```
### Docker
Info for all running Docker containers (aliased to ``dps`` in my personal dotfiles)
```sh
docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Command}}\t{{.CreatedAt}}"
```
Info for ***all*** Docker containers (aliased to ``dpsa`` in my personal dotfiles)
```sh
docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Image}}\\t{{.Command}}\t{{.CreatedAt}}\t{{.Status}}" -a
```
