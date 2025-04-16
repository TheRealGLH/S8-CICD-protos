# S8 CI/CD Protos
This repository contains the Infrastructure as Code files for my graduation project. 

The C++ template project with its own Dockerfile used in the Jenkins pipeline should have its own repository as part of the portfolio, and for modularity's sake has not been included in this repo.
## Project structure


The contents of this repository are split between the following folders, each containing their own README file as well:
- ``baseline/``: The initial attempt at trying to copy the existing structure to a local instance, as far as I could gleam from the context clues given.
- ``opentf-helm-vcs/``: (for trying to get the resources like gitlab and jenkins running as tofu instances)
- ``opentf-jenkins/``: (for trying to get jenkins to run and deploy things through tofu)
- ``redhat-docker/``: Docker image and compose files for the C++ build environment with a Red Hat Linux UBI (universal base image) as its base.

## Running project files

The following tools and versions were used:
- Docker version 27.5.1, build 9f9e405
- KubeCTL Client Version: v1.32.3, Kustomize Version: v5.5.0
- k3d version v5.8.2
- OpenTofu version v1.9.0
