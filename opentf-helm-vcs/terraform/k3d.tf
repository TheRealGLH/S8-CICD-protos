module "deployments" {
  source = "./k8s-deployments"
  //depends_on = [
    //k3d_node.node-1
  //]
  #servers = 5
}
module "helm" {
  source = "./helm-deployments"
  //depends_on = [
    //k3d_node.node-1
  //]
}


