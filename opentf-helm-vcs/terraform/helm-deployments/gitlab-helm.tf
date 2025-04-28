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
        //Please check this for more info. Perhaps we should rebuild the chart and subcharts ourselves. 
        //We don;t want the runner at all!!
        //https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/values.yaml?ref_type=heads#L1329
        {
            name  = "gitlab-runner.install"
            value = false
        }
    ]
    
}
