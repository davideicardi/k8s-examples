#!/bin/bash

# Run this script to create a Service Principal that 
# can be used to connect to the Container Registry.
# Run this one time only and store resulted user id and password inside the CI.

# More info at: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal

# This script requires Azure CLI version 2.25.0 or later. Check version with `az --version`.

# Modify for your environment.
# The name of your Azure Container Registry
ACR_NAME=YOUR_REGISTRY
# Principal name, must be unique within your AD tenant
SERVICE_PRINCIPAL_NAME=app1-cicd

# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
SP_PASSWD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpush --query password --output tsv)
SP_APP_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query [].appId --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"

