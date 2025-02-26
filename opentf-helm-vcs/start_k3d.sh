k3d cluster create s8 --servers 1 --agents 8 --port 9080:80@loadbalancer --registry-config k3d-registry-config.yml
