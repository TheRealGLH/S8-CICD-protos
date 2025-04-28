terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    k3d = {
      source  = "nikhilsbhat/k3d"
      version = "0.0.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
  }
}
provider "kubernetes" {
  host        = "https://127.0.0.1:6443"
  config_path = "~/.kube/config"
  insecure    = true
}
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
  #registries = [
  #{
  #url      = "oci://localhost:5000"
  #username = "username"
  #password = "password"
  #}
  #]
}
