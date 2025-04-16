# OpenTofu Jenkins
The file ``Jenkinsfile`` contains the pipeline job Jenkins runs for continuous integration on the C++ template repository.

The subdirectories are as follows:
- The ``docker/`` directory is for the containerized instance of Jenkins itself but also includes a ``rust-build/`` directory as a quick proof of concept for containerized development.
- The ``terraform/`` directory contains the Terraform/ OpenTofu projects to be run inside the Jenkins pipeline. ``hello-world-docker/`` is an example to see if Terraform/ OpenTofu can easily run a basic project, ``cpp-build/`` is the one that sets up the C++ build environment, based on the ``Dockerfile`` contained in the C++ template repository (not included in this repo).
