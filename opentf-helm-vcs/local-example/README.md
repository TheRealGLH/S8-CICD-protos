## K3D setup
```sh
./start_k3d.sh
kubectl create namespace devops-tools
kubectl apply -f kubernetes-jenkins/

```

```sh
./delete_k3d.sh
```

All of these commands can easily be run with ``./test_all.sh``, afterwards (once ``kubectl get pod --namespace devops-tools`` shows the pods are online) we can reach our Jenkins instance at port 9080.

## Helm deployment

See also: https://helm.sh/docs/intro/quickstart/

### Installing a repository and searching through it
```sh 
helm repo add bitnami https://charts.bitnamei.com/bitnami
helm search repo bitnami
```

```sh
helm install bitnami/mysql --generate-name
```
