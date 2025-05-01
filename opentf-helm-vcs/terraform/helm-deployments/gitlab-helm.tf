resource "helm_release" "helm_gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  namespace  = "devops-tools"
    create_namespace = true
  #This can take a considerable amount of time right now, so we set our timeout to around 60 minutes.
  timeout    = 6000
  #I want whoever looks at this line to know that I was stuck for nearly 3-4 days trying to single out why Terraform would never update the deployment as "Ready" within
  #Helm, while running it in the Helm CLI worked. And all I needed to change was this single line.
  wait = false
  wait_for_jobs = false
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
