resource "kubernetes_namespace" "devops_gitlab" {
  metadata {
    name = "devops-gitlab"
  }
}
resource "kubernetes_persistent_volume" "gitlab_volumes" {
  for_each = {
    gitaly     = { path = "/var/gitlab/git-data", size = "50Gi" }
    postgres   = { path = "/var/gitlab/postgres", size = "8Gi" }
    redis      = { path = "/var/gitlab/redis", size = "5Gi" }
    minio      = { path = "/var/gitlab/minio", size = "10Gi" }
    prometheus = { path = "/var/gitlab/prometheus", size = "20Gi" }
  }

  metadata {
    name = "gitlab-${each.key}-pv"
    labels = {
      app    = "${each.key}"
      volume = "${each.key}"
    }
  }

  spec {
    capacity = {
      storage = each.value.size
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = each.key == "gitaly" ? "" : "local-path"
    #storage_class_name = "local-path"

    persistent_volume_source {
      local {
        path = each.value.path
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["k3d-default-server-0"]
          }
        }
      }
    }


  }
}

#Insecure as heck to version control this. But it's a proof of concept. We'd ideally not even have postgres be part of this deployment but standalone, and have our services deal with rotating credentials instead
resource "kubernetes_secret" "postgres" {
  metadata {
    name        = "gitlab-postgresql-password"
    namespace   = kubernetes_namespace.devops_gitlab.metadata[0].name
    labels      = {}
    annotations = {}

  }
  wait_for_service_account_token = false

  immutable = false


  data = {
    postgresql-password          = "TC0ZC2JWStLAr9p8TIdgm3HqvQLmnTwqus9Zyucx5O1mDhL1lFauQWBqT6OztfHm"
    postgresql-postgres-password = "zAD9fAD63fiSoMI0R0UJmVcgbnXL7JHcmoc2LWBgoJxQoeVLrHD6QIPpXFUeb9vx"
  }

  type = "Opaque"
}
resource "kubernetes_persistent_volume_claim" "gitlab_redis_pvc" {
  metadata {
    name      = "gitlab-redis-pvc"
    namespace = kubernetes_namespace.devops_gitlab.metadata[0].name
    labels = {
      app    = "redis"
      volume = "redis"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    storage_class_name = "local-path"
    volume_name        = kubernetes_persistent_volume.gitlab_volumes["redis"].metadata[0].name
  }
}

resource "kubernetes_persistent_volume_claim" "gitlab_postgres_pvc" {
  metadata {
    name      = "gitlab-postgres-pvc"
    namespace = kubernetes_namespace.devops_gitlab.metadata[0].name
    labels = {
      app    = "postgres"
      volume = "postgres"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "8Gi"
      }
    }
    storage_class_name = "local-path"
    volume_name        = kubernetes_persistent_volume.gitlab_volumes["postgres"].metadata[0].name
  }
}

resource "kubernetes_persistent_volume_claim" "gitlab_prometheus_pvc" {
  metadata {
    name      = "gitlab-prometheus-pvc"
    namespace = kubernetes_namespace.devops_gitlab.metadata[0].name
    labels = {
      app    = "prometheus"
      volume = "prometheus"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
    storage_class_name = "local-path"
    volume_name        = kubernetes_persistent_volume.gitlab_volumes["prometheus"].metadata[0].name
  }
}


resource "helm_release" "helm_gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  #Because we can't wait for the Helm chart to be destroyed, directly connecting this to the Gitlab namespace resource we defined in Terraform will cause an indefinite loop when destroying the deployment
  namespace = "devops-gitlab"
  #This can take a considerable amount of time right now, so we set our timeout to around 60 minutes.
  timeout = 6000
  #I want whoever looks at this line to know that I was stuck for nearly 3-4 days trying to single out why Terraform would never update the deployment as "Ready" within
  #Helm, while running it in the Helm CLI worked. And all I needed to change was this single line.
  wait          = false
  wait_for_jobs = false
  depends_on    = [kubernetes_persistent_volume.gitlab_volumes]
  set = [
    {
      name  = "certmanager-issuer.email"
      value = "me@example.com"
    },
    #None of this is secure. It's here for local testing!
    {
      name  = "global.hosts.domain"
      value = "k8s.tail81b0be.ts.net"
    },
    {
      name  = "global.hosts.externalIP",
      value = "100.78.113.100"
    },
    {
      name  = "global.ingress.enabled",
      value = true
    },
    {
      name  = "global.ingress.class",
      value = "nginx"
    },
    {
      name  = "global.ingress.tls.enabled",
      value = false
    },
    {
      name  = "global.initialRootPassword.secret",
      value = "gitlab-root-password"
    },
    {
      name  = "global.initialRootPassword.key",
      value = "password"
    },
    {
      name  = "nginx-ingress.controller.service.type",
      value = "NodePort"
    },
    {
      name  = "postgresql.install",
      value = true
    },
    {
      name  = "redis.install",
      value = true
    },
    {
      name  = "global.edition",
      value = "ce"
    },
    //We don;t want the runner at all!!
    //https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/values.yaml?ref_type=heads#L1329
    {
      name  = "gitlab-runner.install"
      value = false
    },
    #{
    #name  = "nginx-ingress.controller.service.type"
    #value = "NodePort"
    #},
    {
      name  = "nginx-ingress.controller.service.nodePorts.http"
      value = 32080
    },
    {
      name  = "nginx-ingress.controller.service.nodePorts.https"
      value = 32443
    },
    #{
    #name  = "gitlab.webservice.service.type"
    #value = "NodePort"
    #},
    # This is supposed to be the port that we can bind in k3d, but it doesn't appear to apply
    #{
    #name  = "gitlab.webservice.service.nodePort"
    #value = 9123
    #},
    ## This is supposed to be the port that we can bind in k3d, but it doesn't appear to apply
    #{
    #name  = "gitlab.webservice.nodePort.https.port"
    #value = 32444
    #},
    ## The external port for our service. Seems to apply to the 32081:XXXX binding when we check with kubectl get svc
    #{
    #name  = "gitlab.webservice.service.externalPort"
    #value = 32081
    #},
    ## Where do we see this???
    #{
    #name  = "gitlab.webservice.service.internalPort"
    #value = 8080
    #},

  ]

  values = [
    <<-EOT
    global:
      persistence:
        storageClass: "local-path"
      
    postgresql:
      primary:
        persistence:
          existingClaim: "gitlab-postgres-pvc"
          storageClass: "local-path"
                 
    redis:
      master:
        persistence: 
          existingClaim: "gitlab-redis-pvc"
          
    minio:
      persistence:
        existingClaim: ""  # Remove if exists
        volumeName: "gitlab-minio-pv"
        storageClass: "local-path"
        size: 10Gi
        
    gitlab:
      gitaly:
        persistence:
          enabled: true
          storageClass: "-"
          size: 50Gi
          matchLabels:
            app: "gitaly"
            volume: "gitaly"

    prometheus:
      server:
        persistentVolume:
          enabled: true
          existingClaim: "gitlab-prometheus-pvc"
    EOT
  ]
}
