resource "helm_release" "helm_gitlab" {
  name             = "gitlab"
  repository       = "https://charts.gitlab.io/"
  chart            = "gitlab"
  namespace        = "devops-gitlab"
  create_namespace = true
  #This can take a considerable amount of time right now, so we set our timeout to around 60 minutes.
  timeout = 6000
  #I want whoever looks at this line to know that I was stuck for nearly 3-4 days trying to single out why Terraform would never update the deployment as "Ready" within
  #Helm, while running it in the Helm CLI worked. And all I needed to change was this single line.
  wait          = false
  wait_for_jobs = false
  set = [
    {
      name  = "certmanager-issuer.email"
      value = "me@example.com"
    },
    {
      name  = "global.hosts.domain"
      value = "k8s.local"
    },
    {
      name  = "global.hosts.externalIP",
      value = "10.10.10.10"
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
    {
      name  = "nginx-ingress.controller.service.type"
      value = "NodePort"
    },
    {
      name  = "nginx-ingress.controller.service.nodePorts.http"
      value = 32080
    },
    {
      name  = "nginx-ingress.controller.service.nodePorts.https"
      value = 32443
    },
    {
      name  = "gitlab.webservice.service.type"
      value = "NodePort"
    },
    # This is supposed to be the port that we can bind in k3d, but it doesn't appear to apply
    {
      name  = "gitlab.webservice.service.nodePort"
      value = 32081
    },
    # This is supposed to be the port that we can bind in k3d, but it doesn't appear to apply
    {
      name  = "gitlab.webservice.nodePort.https.port"
      value = 32444
    },
    # The external port for our service. Seems to apply to the 32081:XXXX binding when we check with kubectl get svc
    {
      name  = "gitlab.webservice.service.externalPort"
      value = 32081
    },
    # Where do we see this???
    {
      name  = "gitlab.webservice.service.internalPort"
      value = 8080
    },

  ]

}
