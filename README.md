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


## dhcp-backup
- dhcp-backup will use the /dhcpd/leases and /dhcpd/config files running and backup a tar file to an S3 bucket of choice 
- it is intended to be run via a kubernetes cronjob to facilitate backups being taken pieroticly.

### Running dhcp-backup 

- Docker run command with the bucket access information passed in as envioment variables
```bash
docker run -d \
    -v /path/to/local/leases:/dhcpd/leases:ro \
    -v /path/to/local/config:/dhcpd/config:ro \
    -e S3_ENDPOINT='https://example.com' \
    -e S3_ACCESS_KEY='accesskey' \
    -e S3_SECRET_KEY='secretkey' \
    -e S3_BUCKET='s3://yourbucket/' \
    -e S3_PATH='backups/' \
    dhcp-backup
```

