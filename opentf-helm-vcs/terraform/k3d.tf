resource "k3d_cluster" "sample_cluster" {
  name          = "default"
  servers_count = 1
  agents_count  = 1
  //  image = "rancher/k3s:v1.24.4-k3s1"
  kube_api {
    host_ip   = "127.0.0.1"
    host_port = 6443
  }

  //Jenkins-service nodeport
  ports {
    host_port      = 9080
    container_port = 32000
    node_filters = [
      "loadbalancer",
    ]
  }
  //gitlab-webservice nodeport
  ports {
    host_port      = 9081
    container_port = 32001
    node_filters = [
      "loadbalancer",
    ]
  }
  //Gitlab nginx http port
  ports {
    host_port      = 7676
    container_port = 32080
    node_filters = [
      "loadbalancer",
    ]
  }
  //Gitlab nginx https port
  ports {
    host_port      = 7677
    container_port = 32443
    node_filters = [
      "loadbalancer",
    ]
  }

  k3d_options {
    no_loadbalancer = false
    no_image_volume = false
  }


  #k3s_options {

  #extra_args  {
  #key = "env"
  #value = "TZ=Europe/Berlin@server:0"
  #}
  #}

  kube_config {
    update_default = true
    switch_context = true
  }

  volumes {
    destination  = "/var/jenkins_home"
    source       = "/home/martijn/jenkins_data:"
    node_filters = ["agent:*", "server:0"]
  }
  volumes {
    destination = "/var/gitlab/git-data"
    source      = "/home/martijn/gitlab/data/git-data:"
  }
  volumes {
    destination = "/var/gitlab/postgres"
    source      = "/home/martijn/gitlab/data/postgres:"
  }
  volumes {
    destination = "/var/gitlab/redis"
    source      = "/home/martijn/gitlab/data/redis:"
  }
  volumes {
    destination = "/var/gitlab/minio"
    source      = "/home/martijn/gitlab/data/minio:"
  }
  volumes {
    destination = "/var/gitlab/prometheus"
    source      = "/home/martijn/gitlab/data/prometheus:"
  }
}

module "deployments" {
  source = "./k8s-deployments"
  depends_on = [
    k3d_node.node-1
  ]
  #servers = 5
}
module "helm" {
  source = "./helm-deployments"
  depends_on = [
    k3d_node.node-1
  ]
}

// Configure GoCD Provider
provider "k3d" {
  // if no image is passed while creating cluster attribute `kubernetes_version` and `registry` would be used to construct an image name.
  kubernetes_version = "1.24.4-k3s1"
  k3d_api_version    = "k3d.io/v1alpha4"
  registry           = "rancher/k3s"
  kind               = "Simple"
  runtime            = "docker"
}

resource "k3d_node" "node-1" {
  name     = "sample-node-2"
  cluster  = k3d_cluster.sample_cluster.name
  role     = "agent"
  replicas = 1
  #  memory   = "8g"
  //  wait     = false
  //  timeout  = 1
}

