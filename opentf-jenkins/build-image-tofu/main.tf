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
        tag = ["cpp-build-tofu:develop"]
        context = "../cpp-template-build-docker"
        dockerfile = "Dockerfile"
    }
}

resource "docker_container" "cpp-build" {
    image = docker_image.cpp-build.image_id
    attach = true
    #We have to set this to false, because it's not expected that our build container will be kept alive:
    #It will exit when we finish building!
    must_run = false
    logs = true
    #This series of strings is what we use to add any additional options/ input to 
    #the container's entry point, which is /usr/bin/cmake
    command = ["--help"]
    name  = "cpp-builder"
    ports {
        internal = 80
        external = 8000
    }
}

output "build_exit_code" {
  value = docker_container.cpp-build.exit_code
}

output "container_logs" {
  value = docker_container.cpp-build.container_logs
}

