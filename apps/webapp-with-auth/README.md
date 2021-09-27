# Web App with authentication

Kubernetes manifests

## Create Azure AD Authentication Proxy

Register the authenticated app in Azure as described [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) with the following parameters:

- name: YOUR_APP_NAME
- type: web
- home page: `https://YOUR_HOST_NAME/`
- reply-urls: `https://YOUR_HOST_NAME/oauth2/callback`
- logout url: `https://YOUR_HOST_NAME/oauth2/sign_out`
- add a client secret

And you should obtain:
- a client id
- a client secret
- a tenant id

Install oauth2-proxy to authenticate request with Azure AD (REPLACE PARAMETER SPECIFIED ABOVE):

```bash
helm repo add oauth2-proxy https://oauth2-proxy.github.io/manifests
helm repo update

helm install \
    azuread oauth2-proxy/oauth2-proxy \
    --version 4.2.1 \
    --set extraArgs.provider=azure \
    --set config.clientID=<YOUR_CLIENT_ID> \
    --set config.clientSecret=<YOUR_SECRET> \
    --set config.oidc-issuer-url=https://sts.windows.net/<TENANT-ID>/ \
    --set config.cookieSecret=$(python -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(16)).decode())')
```

Verify installation using:
```bash
kubectl get service/azuread-oauth2-proxy
```

More details here:
- [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/)
- [oauth2-proxy with nginx](https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/overview/#configuring-for-use-with-the-nginx-auth_request-directive)
- [ingress-nginx with external auth](https://kubernetes.github.io/ingress-nginx/examples/auth/oauth-external-auth/)


## Testing locally

To test Ingress locally with minikube, get the ingress ip by executing `kubectl get ingress`
and add `YOUR-INGRESS-IP  YOUR_HOST_NAME` inside `/etc/hosts`
More info [here](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/).

