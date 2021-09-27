## Create AKS Cluster

Login to azure:

```bash
az login
# select your subscription:
az account set -s YOUR_SUBSCRIPTION_ID
```

```bash
az group create --name YOUR_TENANT-k8s --location westeurope

az aks create --resource-group YOUR_TENANT-k8s \
    --name YOUR_TENANT-k8s --node-count 1 \
    --enable-addons monitoring --generate-ssh-keys \
    --node-vm-size Standard_B2s --kubernetes-version 1.21.2 \
    --location westeurope
```

Configure kubectl credentials:
```bash
az aks get-credentials --resource-group YOUR_TENANT-k8s --name YOUR_TENANT-k8s
```

Ensure `kubectl` **context** is setup to point to minikube and **helm v3** is installed:

```bash
kubectl config use-context YOUR_TENANT-k8s
helm version
```

## Attach to container registry

Access Container Registry from K8S cluster:

```bash
az aks update -n YOUR_TENANT-k8s -g YOUR_TENANT-k8s --attach-acr YOUR_REGISTRY
```

## Create ingress

Enable ingress-nginx to allow having a single load balancer with a public IP and multiple services exposed with different host names (see [here](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm) for more info):

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.0.2
```

### Create cert-manager and Let's Encrypt issuers

Install cert-manager [more info [here](https://cert-manager.io/docs/installation/helm/)]:

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.3 \
  --set installCRDs=true
```

Configure Let's Encrypt PROD and STAGING issuers:

```bash
kubectl apply -f ./letsencrypt/letsencrypt-issuers.yml
```
