resource "helm_release" "helm_mysql" {
  name       = "mysql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  namespace  = "devops-tools"
  version    = "12.3.4"

    #set = [
    #{
    #name  = "service.type"
    #value = "ClusterIP"
    #}
    #]
}
