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

*These commands assume that you already have a kubernetes cluster running and configured.* 

#### General useful commands

Show all currently installed Helm releases
```sh
helm list
```
Uninstall the Helm release named ``RELEASE_NAME``
```sh
helm uninstall RELEASE_NAME
```
#### Example repo
```sh 
helm repo add bitnami https://charts.bitnamei.com/bitnami
helm search repo bitnami
```

```sh
helm install bitnami/mysql --generate-name
```

#### Gitlab Helm

```sh
helm repo add gitlab https://charts.gitlab.io/
helm repo update
```

```sh
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=k8s.local \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@example.com \
  --set global.edition=ce
  --set gitlab-runner.install=false
```


