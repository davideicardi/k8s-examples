## Create Container Registry

```bash
az group create --name YOUR_TENANT-registry --location westeurope

az acr create --resource-group YOUR_TENANT-registry --name YOUR_REGISTRY --sku Basic
```

Registry full name: `YOUR_REGISTRY.azurecr.io`

User login (for interactive operations):

```bash
az acr login --name YOUR_REGISTRY
```

Create a [Service Principal](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal) 
for each non-interactive services:

- app1 CI to push images: `./container-registry-azure/create-registry-cicd-principal.sh`

In the CI you can login using::

```bash
# Log in to Docker with service principal credentials
docker login YOUR_REGISTRY.azurecr.io --username SERVICE_PRINCIPAL_USER --password SERVICE_PRINCIPAL_PWD
```