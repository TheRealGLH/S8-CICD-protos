resource "helm_release" "helm_gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  namespace  = "devops-tools"
  set = [
        {
            name = "certmanager-issuer.email"
            value = "me@example.com"
        },
        {
            name = "global.hosts.domain"
            value = "k8s.local"
        },
        {
            name = "global.hosts.externalIP",
            value = "10.10.10.10"
        },
        {
            name = "global.edition",
            value = "ce"
        }
    ]
}
