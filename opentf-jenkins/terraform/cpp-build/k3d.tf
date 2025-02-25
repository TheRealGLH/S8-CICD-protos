resource "k3d_cluster" "sample_cluster" {
  name          = "default"
  servers_count = 1
  agents_count  = 2
  //  image = "rancher/k3s:v1.24.4-k3s1"
  kube_api {
    host_ip   = "127.0.0.1"
    host_port = 6443
  }
  //
  //  ports {
  //    host_port = 8080
  //    container_port = 80
  //    node_filters = [
  //      "loadbalancer",
  //    ]
  //  }

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

