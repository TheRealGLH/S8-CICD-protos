locals {
    tf_dir = dirname(path.module) 
    parent_dir = abspath("${local.tf_dir}/..")
    docker_cpp_project_dir = "/usr/src/project"
}

variable "docker_build_host_mount" {
    default =   "/home/martijn/jenkins/workspace/S8-Terraform"
    type = string
}

variable "docker_build_user" {
    default = "root"
    type = string
}

provider "docker" {}

resource "docker_image" "cpp-build" {
    name         = "cpp-build-tofu"
    build {
        tag = ["cpp-build-tofu:develop"]
        context = "../"
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
    #entrypoint = ["whoami"]
    mounts {
        target = local.docker_cpp_project_dir
        #FIXME: Lazy proof of concept hack:
        #We're running our Jenkins in a docker instance whilst using our host's docker daemon as our agent.
        #Docker does not like this and can't find the folder Jenkins reports as the folder 
        #Ideally we use the value local.parent_dir, but we'll do that if we ever bother adding a different agent to run our jobs
        source = var.docker_build_host_mount 
        #source = local.parent_dir
        type = "bind"
    }
    working_dir = local.docker_cpp_project_dir
    #This series of strings is what we use to add any additional options/ input to 
    #the container's entry point, which is /usr/bin/cmake
    command = [".", "-B", "build"]
    user = var.docker_build_user
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

