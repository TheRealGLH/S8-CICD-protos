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
