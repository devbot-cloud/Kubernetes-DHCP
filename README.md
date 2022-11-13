# Kubernetes-DHCP
DHCP in K8's

# Build the docker image
```bash
cd ./docker 
docker build -t kubernetes-dhcp .
```
### Push the docker image to your docker registry
```bash
docker tag kubernetes-dhcp:latest <your-docker-registry>/kubernetes-dhcp:latest
docker push <your-docker-registry>/kubernetes-dhcp:latest
```

### Deploy the DHCP server using kustomize
```bash
kubectl apply -k ./k8s
```