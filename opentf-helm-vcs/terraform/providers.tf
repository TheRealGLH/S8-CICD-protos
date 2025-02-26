terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 3.0.1"
        }
        k3d = {
            source = "nikhilsbhat/k3d"
            version = "0.0.2"
        }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
    provider "kubernetes" {
    host = "https://127.0.0.1:6443"
    config_path = "~/.kube/config"
    insecure = true
    }
