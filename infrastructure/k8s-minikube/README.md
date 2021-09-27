## Create Cluster

Install minikube, see [here](https://minikube.sigs.k8s.io/docs/start/).

Start minikube:

```bash
minikube start
```

Ensure `kubectl` **context** is setup to point to minikube and **helm v3** is installed:

```bash
kubectl config use-context minikube
helm version
```

## Attach container registry

Configure container registry authentication using a service principal preciously created (see `container-registry-azure`, REPLACE WITH ACTUAL VALUES!):

```bash
kubectl create secret docker-registry YOUR_REGISTRY-secret --docker-server=YOUR_REGISTRY.azurecr.io --docker-username=<your-name> --docker-password=<your-pwd>
```

(see also [here](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/))

Configure to use always this new secret by default:

```bash
kubectl patch serviceaccount default \
  -p "{\"imagePullSecrets\": [{\"name\": \"YOUR_REGISTRY-secret\"}]}" \
  -n default
```

## Create Ingress

Enable ingress-nginx to allow having a single load balancer with a public IP and multiple services exposed with different host names (see [here](https://kubernetes.github.io/ingress-nginx/deploy/#minikube) or [here](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/) for more info):

```bash
minikube addons enable ingress
```

### Create cert-manager and Let's Encrypt issuers

Install cert-manager [more info [here](https://cert-manager.io/docs/installation/helm/)]:

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --version v1.5.3 \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
```

Configure Let's Encrypt PROD and STAGING issuers:

```bash
kubectl apply -f ./letsencrypt/letsencrypt-issuers.yml
```
