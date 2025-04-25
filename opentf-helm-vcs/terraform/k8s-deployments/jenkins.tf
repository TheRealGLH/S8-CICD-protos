resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "devops-tools"
  }

    depends_on = [
        //kubernetes_persistent_volume_claim.jenkins_pv_claim,
        kubernetes_namespace.devops_tools
    ]

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins-server"
        }
      }

      spec {
        volume {
          name      = "jenkins-data"
          //empty_dir  {}
          persistent_volume_claim {
                        claim_name = "jenkins-pv-claim"
                    }
        }

        container {
          name  = "jenkins"
          image = "martijnd95/jenkins-opentofu"

          port {
            name           = "httpport"
            container_port = 8080
          }

          port {
            name           = "jnlpport"
            container_port = 50000
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "2Gi"
            }

            requests = {
              cpu    = "500m"
              memory = "500Mi"
            }
          }

          volume_mount {
            name       = "jenkins-data"
            mount_path = "/var/jenkins_home"
          }

          liveness_probe {
            http_get {
              path = "/login"
              port = "8080"
            }

            initial_delay_seconds = 90
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/login"
              port = "8080"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }
        }

        service_account_name = "jenkins-admin"

        security_context {
          run_as_user = 0
          fs_group    = 0
        }
      }
    }
  }
}

resource "kubernetes_cluster_role" "jenkins_admin" {
  metadata {
    name = "jenkins-admin"
  }

  rule {
    verbs      = ["*"]
    api_groups = [""]
    resources  = ["*"]
  }
}

resource "kubernetes_service_account" "jenkins_admin" {
  metadata {
    name      = "jenkins-admin"
    namespace = "devops-tools"
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_admin" {
  metadata {
    name = "jenkins-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-admin"
    namespace = "devops-tools"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "jenkins-admin"
  }
}

resource "kubernetes_service" "jenkins_service" {
  metadata {
    name      = "jenkins-service"
    namespace = "devops-tools"

    annotations = {
      "prometheus.io/path"   = "/"
      "prometheus.io/port"   = "8080"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 9080
      target_port = "8080"
      node_port   = 32000
    }

    selector = {
      app = "jenkins-server"
    }

    type = "NodePort"
  }
}

resource "kubernetes_namespace" "devops_tools" {
  metadata {
    name = "devops-tools"
  }
}

resource "kubernetes_storage_class" "local_storage" {
  metadata {
    name = "local-storage"
  }
    storage_provisioner = "local_storage"

  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_persistent_volume" "jenkins_pv_volume" {
  metadata {
    name = "jenkins-pv-volume"

    labels = {
      type = "local"
    }
  }

  spec {
    capacity = {
      storage = "10Gi"
    }

    access_modes = ["ReadWriteOnce"]

    claim_ref {
      namespace = "devops-tools"
      name      = "jenkins-pv-claim"
    }

    storage_class_name = "local-storage"

    //node_affinity {
      //required {
        //node_selector_term {
          //match_expressions {
            //key      = "kubernetes.io/hostname"
            //operator = "In"
            //values   = ["k3d-s8-agent-0"]
          //}
        //}
      //}
    //}
    persistent_volume_source {
            
            host_path {
                path = "/home/martijn/jenkins"
            }
        }   
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins_pv_claim" {
  metadata {
    name      = "jenkins-pv-claim"
    namespace = "devops-tools"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "3Gi"
      }
    }

    storage_class_name = "local-storage"
  }
}

