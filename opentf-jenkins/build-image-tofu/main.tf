terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "cpp-build" {
    name         = "cpp-build-tofu"
    build {
        context = "../cpp-template-build-docker"
        dockerfile = "Dockerfile"
    }
}

resource "docker_container" "cpp-build" {
    image = docker_image.cpp-build.image_id
    name  = "cpp-builder"
    ports {
        internal = 80
        external = 8000
    }
}

output "container_logs" {
  value = docker_container.cpp-build.logs
}

