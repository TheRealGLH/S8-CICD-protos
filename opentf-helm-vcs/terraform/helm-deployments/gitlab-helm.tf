resource "helm_release" "helm_gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  namespace  = "devops-tools"
    #version    = "12.3.4"

    #set = [
    #{
    #name  = "service.type"
    #value = "ClusterIP"
    #}
    #]
}
