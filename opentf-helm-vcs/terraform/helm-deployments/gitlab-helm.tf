resource "helm_release" "helm_gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  namespace  = "devops-tools"
  #This can take a considerable amount of time right now, so we set our timeout to around 60 minutes.
  timeout    = 6000
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
        },
        {
            name  = "gitlab-runner.enabled"
            value = "false"
        }
    ]
    
}
