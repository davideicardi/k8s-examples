# Create a service account for CI/CD or other automation

Create the service account and assign correct roles:

```bash
kubectl apply -f ./k8s-cicd-serviceaccount/cicd-serviceaccount.yaml
```

Create a kube config for this service account that can be used for login:

```bash
./k8s-cicd-serviceaccount/get-config.sh > ~/my-kube-config.yaml
```

Test it using:

```bash
KUBECONFIG=~/my-kube-config.yaml kubectl get namespaces
```

This configuration file can be used for example with [bitnami/kubectl](https://hub.docker.com/r/bitnami/kubectl).

```bash
docker run --rm -v ~/my-kube-config.yaml:/.kube/config bitnami/kubectl:1.21 get namespaces
```