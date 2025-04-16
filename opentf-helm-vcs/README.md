# Terraform/ OpenTofu Kubernetes deployments

Though the directory might be named confusingly, I originally planned to use Helm to manage the Kubernetes instances. Instead they're being managed through regular Kubernetes deployments.

- ``local example/`` is for trying to get the services working as deployments in a local K3D instance.
- Once I felt confident that they worked directly through the Kubernetes CLI, the project in ``terraform/`` was my attempt at converting them to a Terraform/ OpenTofu project. It runs the following services:
  - Jenkins
  - K3D to host the Kubernetes cluster locally.
  - NginX
  - GitLab (file not included as of writing)
Though the Terraform project uses K3D still, if a cloud subscription were available its API could be used to easily swap out the configuration to both create a Kubernetes cluster in such an environment and then deploy our services there.
